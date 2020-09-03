package com.example.knaev.fotball;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.TextView.OnEditorActionListener;
import java.net.*;
import java.io.*;
import java.util.ArrayList;
import java.util.List;







public class MainActivity extends Activity {



    EditText  koord;

    Socket s;
    DataInputStream din;
    DataOutputStream dout;
    //BufferedReader br;
    String IPadress;
    int PORT;

//send over hele arrayet. og hvis det ikke går ann, behold kun det gamle arrayet!

    String STATUS;
    List<String> GOAL = new ArrayList();

    int workCount=0;

    public void sendMessage(String argument, char specifier){
        if(specifier=='K'){
            try{
                s=new Socket(IPadress,PORT);
                din=new DataInputStream(s.getInputStream());
                dout=new DataOutputStream(s.getOutputStream());
                //br=new BufferedReader(new InputStreamReader(System.in));
                Toast.makeText(getBaseContext(), "SENDER", Toast.LENGTH_LONG).show();

                dout.writeUTF(argument);

                dout.flush();
                dout.close();
                s.close();

                GOAL.add(argument);

            }catch(IOException fail){
                Toast.makeText(getBaseContext(),"Problem med sending. Jobb ble ikke lagt til", Toast.LENGTH_LONG).show();
            }

        }else if(specifier=='S'){
            try{
                s=new Socket(IPadress,PORT);
                din=new DataInputStream(s.getInputStream());
                dout=new DataOutputStream(s.getOutputStream());
                //br=new BufferedReader(new InputStreamReader(System.in));
                Toast.makeText(getBaseContext(), "SENDER", Toast.LENGTH_LONG).show();

                dout.writeUTF(argument);

                dout.flush();
                dout.close();
                s.close();

                GOAL.clear();


            }catch(IOException fail){
                Toast.makeText(getBaseContext(),"Problem med sending. Status:" + " " + STATUS + " "+ "ble ikke lagt til", Toast.LENGTH_LONG).show();
            }

        }else if(specifier=='V'){
            try{
                s=new Socket(IPadress,PORT);
                din=new DataInputStream(s.getInputStream());
                dout=new DataOutputStream(s.getOutputStream());
                //br=new BufferedReader(new InputStreamReader(System.in));
                Toast.makeText(getBaseContext(), "SENDER", Toast.LENGTH_LONG).show();
                dout.writeUTF(argument);
                dout.flush();
                dout.close();

                s.close();


            }catch(IOException fail){
                Toast.makeText(getBaseContext(),"Problem med sending. Status:" + " " + STATUS + " "+ "ble ikke lagt til", Toast.LENGTH_LONG).show();
            }
        }
    }











    public boolean SparseInput(String Input) {

        String strOut1 = Input.substring(0,Input.indexOf('.'));
        String strOut2= Input.substring(Input.indexOf('.')+1,Input.length());

        try{
            int foo = Integer.parseInt(strOut1);
            int foo2 = Integer.parseInt(strOut2);
            //Toast.makeText(getBaseContext(), "SPARSE OK", Toast.LENGTH_LONG).show();

            return true;

        }catch(NumberFormatException fail){
            return false;
        }
    };

    public boolean CheckRightInputForm(String Input){
        int dotCount = 0;

        for(int i=0; i<Input.length();i++){
            if(Input.charAt(i)=='.'){
                dotCount++;
            }
        }

        if(dotCount==1){
           // Toast.makeText(getBaseContext(), "DOT OK", Toast.LENGTH_LONG).show();
            return true;
        }else{
            return false;
        }
    };

    public String getValue(String Input){

        String strOut1 = Input.substring(0,Input.indexOf("."));
        String strOut2= Input.substring(Input.indexOf(".") + 1,Input.length());
        int foo = Integer.parseInt(strOut1);
        int foo2 = Integer.parseInt(strOut2);

        int[] values=new int[2];
        values[0]=foo;
        values[1]=foo2;
        workCount++;
        String VAL=values.toString() + " " + workCount;

        return VAL;
    };



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);



        koord = (EditText) findViewById(R.id.koord);




        final Button nedEdit = (Button) findViewById(R.id.Ned);
        final Button oppEdit  = (Button) findViewById(R.id.Opp);
        final Button venEdit = (Button) findViewById(R.id.Venstre);
        final Button hoyEdit = (Button) findViewById(R.id.Høyre);
        final Button skytEdit = (Button) findViewById(R.id.Skyt);
        final Button Stop = (Button) findViewById(R.id.Stop);
        final CheckBox ch1 = (CheckBox) findViewById(R.id.Kontinuerlig);





        ch1.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v){
                if(ch1.isChecked()){
                    Toast.makeText(getBaseContext(), "Checkbox is checked", Toast.LENGTH_LONG).show();
                }else{
                    Toast.makeText(getBaseContext(), "Checkbox is unchecked", Toast.LENGTH_LONG).show();
                }
            }
        });





        oppEdit.setOnClickListener(new  OnClickListener() {


            public void onClick(View oppEdit) {

                if(GOAL.size()==0){
                    if (ch1.isChecked()){
                        STATUS="OPP";
                        Toast.makeText(getBaseContext(), STATUS, Toast.LENGTH_SHORT).show();
                        sendMessage(STATUS,'V');

                    }else{
                        Toast.makeText(getBaseContext(),"KOORDINATER", Toast.LENGTH_SHORT).show();
                    }

                }else{
                    Toast.makeText(getBaseContext(),"Målet, koordinatene du ga, er ikke nådd", Toast.LENGTH_SHORT).show();
                }


            }
        });

        nedEdit.setOnClickListener(new  OnClickListener() {


            public void onClick(View v) {

                if(GOAL.isEmpty()){
                    if (ch1.isChecked()){
                        STATUS="NED";
                        Toast.makeText(getBaseContext(), STATUS, Toast.LENGTH_SHORT).show();
                        sendMessage(STATUS,'V');

                    }else{
                        Toast.makeText(getBaseContext(),"KOORDINATER", Toast.LENGTH_SHORT).show();
                    }
                }else{
                    Toast.makeText(getBaseContext(),"Målet, koordinatene du ga, er ikke nådd", Toast.LENGTH_SHORT).show();
                }



            }
        });

        venEdit.setOnClickListener(new  OnClickListener() {


            public void onClick(View v) {

                if(GOAL.isEmpty()){

                    if (ch1.isChecked()){
                        STATUS="VENSTRE";
                        Toast.makeText(getBaseContext(), STATUS, Toast.LENGTH_SHORT).show();
                        sendMessage(STATUS,'V');

                    }else{
                        Toast.makeText(getBaseContext(),"KOORDINATER", Toast.LENGTH_SHORT).show();
                    }

                }else{
                    Toast.makeText(getBaseContext(),"Målet, koordinatene du ga, er ikke nådd", Toast.LENGTH_SHORT).show();
                }

            }
        });

        hoyEdit.setOnClickListener(new  OnClickListener() {


            public void onClick(View v) {

                if(GOAL.isEmpty()){
                    if (ch1.isChecked()){
                        STATUS="HØYRE";
                        Toast.makeText(getBaseContext(), STATUS, Toast.LENGTH_SHORT).show();
                        sendMessage(STATUS,'V');
                    }else{
                        Toast.makeText(getBaseContext(), "KOORDINATER", Toast.LENGTH_SHORT).show();
                    }
                }else{
                    Toast.makeText(getBaseContext(),"Målet, koordinatene du ga, er ikke nådd", Toast.LENGTH_SHORT).show();
                }

            }
        });



        skytEdit.setOnClickListener(new  OnClickListener() { //Husk aa stoppe før skyte!

            public void onClick(View v) {

                if(GOAL.isEmpty()){
                    if (ch1.isChecked()){
                        STATUS ="SHOOT";
                        sendMessage(STATUS,'V');
                        Intent intent = new Intent(v.getContext(), MainActivity2Activity.class);
                        startActivityForResult(intent, 0);
                    }else{
                        Toast.makeText(getBaseContext(), "KOORDINATER", Toast.LENGTH_SHORT).show();
                    }

                }else{
                    Toast.makeText(getBaseContext(),"Målet, koordinatene du ga, er ikke nådd", Toast.LENGTH_SHORT).show();
                }
            }
        });

        koord.setOnEditorActionListener(new OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                boolean handled = false;
                if(ch1.isChecked()==false){
                    if(actionId==EditorInfo.IME_ACTION_SEND){


                        Toast.makeText(getBaseContext(),  v.getText().toString(), Toast.LENGTH_SHORT).show();


                        if(CheckRightInputForm(v.getText().toString()) && SparseInput(v.getText().toString())){
                            Toast.makeText(getBaseContext(), "MESSAGE BLE SENDT" + " " + v.getText().toString(), Toast.LENGTH_SHORT).show();
                            sendMessage(getValue(v.getText().toString()),'K');
                        }else{
                            Toast.makeText(getBaseContext(), "IKKE EN DRITT BLE GJORT. FEIL FORMAT PÅ INPUT (xx.yy)", Toast.LENGTH_SHORT).show();
                        }

                        koord.setText("");
                        InputMethodManager imm = (InputMethodManager) getSystemService(Activity.INPUT_METHOD_SERVICE);
                        imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0);
                        handled = true;
                    }
                }else{
                    Toast.makeText(getBaseContext(), "STYRING ER KONTINUERLIG", Toast.LENGTH_SHORT).show();

                    koord.setText("");
                    InputMethodManager imm = (InputMethodManager) getSystemService(Activity.INPUT_METHOD_SERVICE);
                    imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0);
                    handled = true;
                }
                return handled;
            }
        });




        Stop.setOnClickListener(new  OnClickListener() {


            public void onClick(View v) {
                STATUS="STOP";
                sendMessage(STATUS,'S');

            }
        });
    }






    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }


}

