from Tkinter import *
#import tkFiledialog
        #from ttk import *
from Kontroll import Communication
from Arduino import Arduino


class KontrollPanel(Frame):
        def __init__(self,master=None):
                Frame.__init__(self,master,relief="groove")
                self.master=master
                self.grid()
                self.com=Communication()
                self.ardu=Arduino()
                self.master.protocol('WM_DELETE_WINDOW', self.exit_panel)
                self.checkspinn=BooleanVar()
                self.checkstrom=BooleanVar()
                self.checkspeed_m1=BooleanVar()
                self.checkspeed_m2=BooleanVar()

                self.loggingnavn=StringVar()
                self.samplerate=IntVar()
                self.duration=IntVar()
                self.fartvar=DoubleVar()
                self.spinvar=DoubleVar()
                self.ballchoicevar=IntVar()
                self.vert=DoubleVar()
                self.shooterSpeed=DoubleVar()
                self.createWidgets()

        def createWidgets(self):
                self.ballframe=Frame(self)
                self.ballframe.grid(row=0,column=0)
                Label(self.ballframe,text='Fart').grid(row=0,column=0)
                Entry(self.ballframe,textvariable=self.fartvar).grid(row=0,column=1)
                Label(self.ballframe,text='Spinn').grid(row=0,column=2)
                Entry(self.ballframe,textvariable=self.spinvar).grid(row=0,column=3)
                Label(self.ballframe,text='Vertikal posisjon').grid(row=1,column=0)
                Entry(self.ballframe,textvariable=self.vert).grid(row=1,column=1)
                Label(self.ballframe,text='Utskyter hastighet').grid(row=1,column=2)
                Entry(self.ballframe,textvariable=self.shooterSpeed).grid(row=1,column=3)
                self.spinncheck=Checkbutton(self.ballframe,text="Spinn",variable=self.checkspinn)
                self.spinncheck.grid(row=2,column=0)

                #Label(self.ballframe,text='Ball-mater').grid(row=2,column=0)
                #Scale(self.master, from_=0, to=100, orient=HORIZONTAL).grid(row=2,column=1)

                self.ButtonFrame=Frame(self.ballframe)
                self.ButtonFrame.grid(row=3,column=0)
                self.speedButton=Button(self.ButtonFrame,text="Sett fart",command=self.set_speed)
                self.speedButton.grid(row=0,column=0)
                self.resetspeedButton=Button(self.ButtonFrame,text="Nullstill",command=self.zero_speed)
                self.resetspeedButton.grid(row=0,column=1)
                self.calibrateButton=Button(self.ButtonFrame,text="Kalibrer", command=self.calibrate)
                self.calibrateButton.grid(row=0,column=2)
                self.vertButton=Button(self.ButtonFrame,text="Sett vertikal",command=self.set_verticle)
                self.vertButton.grid(row=0,column=3)
                self.vertButton=Button(self.ButtonFrame,text="Sett skytehastighet",command=self.set_ball_shooter_speed)
                self.vertButton.grid(row=0,column=4)
		#self.choose_ball=Button(self.ButtonFrame,text='Ballmeny',command=self.choose_ball_menu)
                                
                self.loggframe=Frame(self)
                self.loggframe.grid(row=0,column=1)
                self.loggSM1check=Checkbutton(self.loggframe,text="strom",variable=self.checkstrom,command=self.update_loggingflags)
               
                self.loggFM1check=Checkbutton(self.loggframe,text="fart m1",variable=self.checkspeed_m1,command=self.update_loggingflags)
                self.loggFM2check=Checkbutton(self.loggframe,text="fart m2",variable=self.checkspeed_m2,command=self.update_loggingflags)
                self.loggSM1check.grid(row=0,column=0)
            
                self.loggFM1check.grid(row=1,column=0)
                self.loggFM2check.grid(row=1,column=1)

                self.loggbutton=Button(self.loggframe,text='Logg',command=self.start_logging)
                self.loggkonfig=Button(self.loggframe,text='Konfig Logging',command=self.config_logging_window)
                self.loggbutton.grid(row=2,column=0)
                self.loggkonfig.grid(row=2,column=1)
                
        def config_logging_window(self):
                self.config=Toplevel()
                self.config.title('Konfigurasjoner av loggingen av systemet')
                Label(self.config,text='Navn').grid(row=0,column=0,sticky=W+N+E+S)
                Entry(self.config,textvariable=self.loggingnavn).grid(row=0,column=1,sticky=W+N+E+S)
                Label(self.config,text="Samplerate").grid(row=1,column=0,sticky=W+N+E+S)
                Entry(self.config,textvariable=self.samplerate).grid(row=1,column=1,sticky=W+N+E+S)
                Label(self.config,text='Varighet').grid(row=2,column=0,sticky=W+N+E+S)
                Entry(self.config,textvariable=self.duration).grid(row=2,column=1,sticky=W+N+E+S)
                Button(self.config,text='OK',command=self.exit_config).grid(row=3,column=0,sticky=W+N+E+S)
        #def choose_ball_menu(self):
        #        self.ballmenu=Toplevel()
        #        self.ballmenu.title('Ballmeny'):
        #        Button(self.ballmenu,text='last ball',command=self.update_ball_list).grid(row=0,column=0)
        #        self.make_radio_buttonlist(self.ballmenu)
        def update_ball_list(self):
                adress=tkFileDialog.askopenfilename()
                self.com.load_ball(adress)
                self.make_radio_buttonlist(self.ballmenu)
        def make_radio_buttonlist(self,master):
                for i,ball in enumerate(self.com.Ball_list):
                        Radiobutton(master,text=str(ball.name),variable=self.ballchoicevar,value=i,command=self.update_active_ball).grid(row=i+1,column=0)
                
        def update_active_ball(self):
                self.com.set_active_ball(self.ballchoicevar.get())
        def calibrate(self):
                calibM1,calibM2=self.com.calibrate_motors(self.fartvar.get())

        def start_logging(self):
                if not self.com.is_collecting():
                        self.com.start_collector()
                self.com.start_collecting()
        def update_loggingflags():
                self.com.set_loggingflags(self.checkspeed_m1.get(),self.checkspeed_m2.get(),self.checkstrom.get())       
        def set_speed(self):
  
                if self.fartvar.get()<=0:
                        print("maa oppgi en gyldig hastighet!")
                        return False
                
                elif self.checkspinn.get():
                        self.com.set_spinn_and_velocity_ball(self.spinvar.get(),self.fartvar.get())
                        print("satt hastighet og spinn")
                        return True
                else:
                        self.com.set_speed_ball(self.fartvar.get())
                        print("satt hastighet uten spinn")
                        return True
        
        def set_verticle(self):
                if self.vert.get()<0 and self.vert.get()>80:
                        print("maa oppgi en gyldig vinkel!")
                        return False
                else:
                        self.ardu.set_verticle(self.vert.get())
                        print("satt vertikal vinkel")
                        return True

        def set_ball_shooter_speed(self):
                if self.shooterSpeed.get()<0 and self.shooterSpeed.get()>90:
                        print("maa oppgi en gyldig vinkel!")
                        return False
                else:
                        self.ardu.set_ball_shooter_speed(self.shooterSpeed.get())
                        print("satt vertikal vinkel")
                        return True  
                        
        def zero_speed(self):
                self.com.set_speed_ball(0)
                self.ardu.set_ball_shooter_speed(0)
                self.ardu.set_verticle(0)
                return True
        
      
        def exit_config(self):
                print("placeholder")
                self.update_configvars()

                self.config.destroy()
        def update_configvars(self):
                print("placeholder")
                self.com.set_samplerate(self.samplerate.get())
                self.com.set_duration(self.duration.get())
                self.com.set_name(self.loggingnavn.get())
        
        def exit_panel(self):
                self.zero_speed()
                self.com.close()
                if self.master==None:
                        self.destroy()
                else:
                        self.master.destroy()


root = Tk()
app = KontrollPanel(root)
app.grid(sticky=W+E+N+S)


app.mainloop()

