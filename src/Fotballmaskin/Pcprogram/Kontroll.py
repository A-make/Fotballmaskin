import sys
import scipy.io as sio
from roboclaw.roboclaw import Roboclaw
from threading import Thread, Event
import numpy as np
import Queue
import time
import random

class Communication:
    def __init__(self,port='COM6'):
        self.Robo=Roboclaw(port)
        self.Collector=Collect_Data(self.Robo)
        self.calibM1=1
        self.calibM2=1
        self.ball_list=[]
        self.active_ball=Ball()
    def run_array_on_motor(self,array,duration):
        if not self.Collector.is_alive():
            self.Collector.start()
        self.Collector._run.set()                
        delay=float(duration)/float(len(array))
        prev_value=0

        for value in array:
            if prev_value!=value:
                self.set_speedM1(value)
                self.set_speedM2(value)
                prev_value=value
            time.sleep(delay)
        self.set_speedM1(0)
        self.set_speedM2(0)
        self.stop_collecting()
        time.sleep(30)
	                        
    def run_array_on_motor2(self,array,duration):
        if not self.Collector.is_alive():
            self.Collector.start()
        self.Collector._run.set()
        delay=float(duration)/float(len(array))
        prev_value=0

        for value in array:
            self.Robo.mutex.acquire()
            if prev_value!=value:
                print(64+int(round(value,1)*6))
                self.Robo.DriveM1(64+int(round(value,1)*6))
                self.Robo.DriveM2(64+int(round(value,1)*6))     
            self.Robo.mutex.release()
            prev_value=value
            time.sleep(delay)
        self.Robo.DriveM1(64)
        self.Robo.DriveM2(64)

        self.stop_collecting()
        time.sleep(30)

    def set_speedM1(self,spin):
        #speedreached=False
        quadspeed=int(round(spin*4000))
        print(quadspeed)
        self.Robo.mutex.acquire()               
        self.Robo.SetM1Speed(quadspeed)
        self.Robo.mutex.release()       
        return True
    
    def set_speedM2(self,spin):             
        quadspeed=int(round(spin*4000))
        print(quadspeed)
        self.Robo.mutex.acquire()
        self.Robo.SetM2Speed(quadspeed)
        self.Robo.mutex.release()
        return True
            
    def set_speed_ball(self,velocity):
        spin=-velocity/(0.1*2*np.pi)
        spinM1=self.calibM1*spin
        spinM2=self.calibM2*spin
        if spinM1<-184879 or spinM2<-178401:
            print("speed is to high!")
            return False
        flagM1=self.set_speedM1(spinM1)
        flagM2=self.set_speedM2(spinM2)
        if not flagM1 and flagM2:
            return False
        return True

    def set_active_ball(self,index):
        self.active_ball=self.ball_list[index]

    def set_spinn_and_velocity_ball(self,bspin=0,velocity=0):
        spin=-velocity/(0.1*np.pi)
        spinM1=spin-(bspin/np.pi)
        spinM2=spin+(bspin/np.pi)
        flagM1=self.set_speedM1(spinM1)
        flagM2=self.set_speedM2(spinM2)

    def calibrate_motors(self,fart):
        self.calibM1=1
        self.calibM2=1
        self.set_speed_ball(fart)
        time.sleep(5)
        print("insert the ball")
        self.start_collecting()
        self.Collector._runinv.wait()
        print("max speed for m1 is"+str(self.Collector.min_m1*0.1*2*np.pi))
        calibM1=1+(1-(-1*self.Collector.min_m1*(0.1*2*np.pi))/fart)
        print(calibM1)
        calibM2=1+(1-(-1*self.Collector.min_m2*(0.1*2*np.pi))/fart)
        print(calibM2)
        self.calibM1=calibM1
        self.calibM2=calibM2
        self.set_speed_ball(0)
        self.Collector._runinv.clear()
        return self.calibM1,self.calibM2

    def is_collecting(self):
        return self.Collector.is_alive()

    def start_collector(self):
    	self.Collector.start()

    def start_collecting(self):
        if not self.Collector.is_alive():
            self.Collector.start()
        self.Collector._run.set()

    def stop_collecting(self):
        self.Collector._run.clear()
            
    def get_loggingflags(self):
        return self.Collector.get_loggingflags

    def set_loggingflags(self,flags):
        self.Collector.update_flags()

    def set_samplerate(self,samplerate):
    	self.Collector.samplerate=int(samplerate)

    def set_duration(self,duration):
    	self.Collector.time=int(duration)

    def set_name(self,name):
    	self.Collector.name=str(name)

    def set_ball(self,ball='ball'):
        ballfound=False
        for b in self.balls:
            if b.name==ball:
                ballfound=True
                self.calibM1=b.calibM1
                self.calibM2=b.calibM2
        if ballfound:
            print("found ball")
        else:
            print("this ball does not exist in the machine")
        return ballfound

    def load_ball(self,adress):
        ball=Ball()
        tempball=sio.loadmat(adress)
        ball.name=tempball['name']
        ball.calibM1=tempball['calibM1']
        ball.calibM2=tempball['calibM2']
        self.ball_list.append(ball)

    def close(self):
        if self.Collector.is_alive():
            self.Collector.stop()
            self.Collector.join()
        self.Robo.port.close()


class Collect_Data(Thread):
    def __init__(self,comm,time=10,samplerate=10):
        Thread.__init__(self)
        self.daemon=True
        self._stop=Event()
        self._run=Event()
        self._runinv=Event()
        self.comm=comm
        self.name=''
        self.time=time
        self.samplerate=samplerate
        self.delay=float(1/float(samplerate))
        self.iterations=time*samplerate
        self.min_m1=0
        self.min_m2=0
        self.loggspeed=[1,1]
        self.loggcurrent=1
        self.encoderconst=float(4000)
        self.currentconst=float(0.1)
        self.current_m1=np.zeros((self.iterations,2))
        self.current_m2=np.zeros((self.iterations,2))
        self.speed_m1=np.zeros((self.iterations,2))
        self.speed_m2=np.zeros((self.iterations,2))
        self.testnumber=0

    def run(self):
        while not self._stop.isSet():
            self._run.wait()
            self._runinv.clear()
            if self._stop.isSet():
                print("stopping")
                break
                    
            self.testnumber +=1
            self.clear_arrays()
            for i in range(self.iterations):
                start_time=time.time()
                self.comm.mutex.acquire()
                if self.loggcurrent:
                    cm1,cm2=self.comm.readcurrents()
                    self.current_m1[i,1]=cm1*self.currentconst
                    self.current_m2[i,1]=cm2*self.currentconst
             
                if self.loggspeed[0]:
                    sm1,statusm1=self.comm.readM1speed()
                    self.speed_m1[i,1]=sm1/self.encoderconst
                    print(self.speed_m1[i,1]*2*0.1*np.pi)
                if self.loggspeed[1]:
                    sm2,statusm2=self.comm.readM2speed()
                    self.speed_m2[i,1]=sm2/self.encoderconst
                    print(self.speed_m2[i,1]*2*0.1*np.pi)
                self.comm.mutex.release()
                    
                end_time=time.time()
                if self.delay-(end_time-start_time)>0:
                    time.sleep(self.delay-(end_time-start_time))
                    self.current_m1[i,0]=self.current_m1[i-1,0]+self.delay
                    self.speed_m1[i,0]=self.speed_m1[i-1,0]+self.delay
                    self.current_m2[i,0]=self.current_m2[i-1,0]+self.delay
                    self.speed_m2[i,0]=self.speed_m2[i-1,0]+self.delay
            
                else:
                    self.current_m1[i,0]=self.current_m1[i-1,0]+(end_time-start_time)
                    self.speed_m1[i,0]=self.speed_m1[i,0]+(end_time-start_time)
                    self.current_m2[i,0]=self.current_m2[i-1,0]+(end_time-start_time)
                    self.speed_m2[i,0]=self.speed_m2[i-1,0]+(end_time-start_time)
                    continue

            self.update_max()
            self.save_data()
            self.done()

    def go(self):
        self._run.set()

    def is_going(self):
        return self._run.is_set()

    def done(self):
        self._run.clear()
        self._runinv.set()

    def stop(self):
        self._stop.set()
        self._run.set()

    def stopped(self):
        return self._stop.isSet()

    def clear_arrays(self):
        self.current_m1=np.zeros((self.iterations,2))
        self.current_m2=np.zeros((self.iterations,2))
        self.speed_m1=np.zeros((self.iterations,2))
        self.speed_m2=np.zeros((self.iterations,2))

    def save_data(self):
        if self.loggcurrent:
            sio.savemat(self.name+'current_m1_'+str(self.testnumber)+'.mat',{'current_m1_'+str(self.testnumber):self.current_m1})
            sio.savemat(self.name+'current_m2_'+str(self.testnumber)+'.mat',{'current_m2_'+str(self.testnumber):self.current_m2})
        if self.loggspeed[0]:
            sio.savemat(self.name+'speed_m1_'+str(self.testnumber)+'.mat',{'speed_m1_'+str(self.testnumber):self.speed_m1})
        if self.loggspeed[1]:
            sio.savemat(self.name+'speed_m2_'+str(self.testnumber)+'.mat',{'speed_m2_'+str(self.testnumber):self.speed_m2})


    def ArraytoMat(self,destination,name,array):
        sio.savemat('destination',mdict={name: array})  

    def update_flags(self,speedm1,speedm2,current):
        self.loggspeed=[speedm1,speedm2]
        self.loggcurrent=current

    def update_max(self):
    	self.min_m1=max(self.speed_m1[:,1])
    	self.min_m2=max(self.speed_m2[:,1])

class Ball:
    def __init__(self,name='ball',calibM1=1,calibM2=1):
        self.name=name
        self.calibM1=calibM1
        self.calibM2=calibM2
    def save_ball(self,adress=''):
        sio.savemat(adress+self.name+'.mat',mdict={'name':self.name,'calibM1':self.calibM1,'calibM2':self.calibM2 }) 
            
def step_response(steptime=1, startvalue=0,endvalue=1,duration=15,samplerate=5):
    delay=float(duration*samplerate)
    t=np.array(range(0,int(duration*samplerate+1)))/(duration/float(samplerate))
    step=steptime*samplerate
    stepres=np.ones(duration*samplerate)*startvalue
    stepres[step-1:]=endvalue
    return (stepres,t,duration)

#com=Communication()
#for i in range(4):
#	stepres,t,duration=step_response(endvalue=(i+1)*5)
#	com.run_array_on_motor(stepres,duration)
