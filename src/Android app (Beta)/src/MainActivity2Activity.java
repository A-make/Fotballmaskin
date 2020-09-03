package com.example.knaev.fotball;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Button;
import android.app.Activity;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.TextView.OnEditorActionListener;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;


public class MainActivity2Activity extends ActionBarActivity {

    EditText  spinHoyre, spinVenstre;
    String STATUS;
    String spinV;
    String spinH;

    Socket s;
    DataInputStream din;
    DataOutputStream dout;
    //BufferedReader br;
    String IPadress;
    int PORT;





    public String getValue(){
        String[] arr;
        arr=new String[2];
        arr[0]=spinH;
        arr[1]=spinV;
        Toast.makeText(getBaseContext(),arr[0] + " "+ arr[1], Toast.LENGTH_LONG).show();
        String VAL=arr.toString();
        return VAL;
    }

    public void sendMessage(String argument){
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
            Toast.makeText(getBaseContext(),"Problem med sending. Jobb ble ikke lagt til", Toast.LENGTH_LONG).show();
        }
    }



    public void onBackPressed(){
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setCancelable(false);
        builder.setMessage("Do you want to Exit?");
        builder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //if user pressed "yes", then he is allowed to exit from application
                STATUS="DONE";
                Toast.makeText(getBaseContext(),STATUS, Toast.LENGTH_LONG).show();

                sendMessage(STATUS);
                finish();
            }
        });
        builder.setNegativeButton("No",new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                //if user select "No", just cancel this dialog and continue with app
                dialog.cancel();
            }
        });
        AlertDialog alert=builder.create();
        alert.show();
    }







    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_activity2);






        final Button Shoot = (Button) findViewById(R.id.Shoot);



        spinHoyre = (EditText) findViewById(R.id.spinHoyre);
        spinVenstre = (EditText) findViewById(R.id.spinVenstre);

        Shoot.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                STATUS="SHOOT";
                Toast.makeText(getBaseContext(),"JAJAJAJ", Toast.LENGTH_LONG).show();
                sendMessage(getValue());
            }
        });






        spinHoyre = (EditText) findViewById(R.id.spinHoyre);
        spinVenstre = (EditText) findViewById(R.id.spinVenstre);

        spinHoyre.setOnEditorActionListener(new OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                boolean handled = false;

                if (actionId == EditorInfo.IME_ACTION_SEND) {


                    Toast.makeText(getBaseContext(), v.getText().toString(), Toast.LENGTH_SHORT).show();


                    InputMethodManager imm = (InputMethodManager) getSystemService(Activity.INPUT_METHOD_SERVICE);
                    imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0);
                    spinH=v.getText().toString();
                    handled = true;

                }


                return handled;
            }
        });



        spinVenstre.setOnEditorActionListener(new OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                boolean handled = false;

                if (actionId == EditorInfo.IME_ACTION_SEND) {


                    Toast.makeText(getBaseContext(), v.getText().toString(), Toast.LENGTH_SHORT).show();


                    InputMethodManager imm = (InputMethodManager) getSystemService(Activity.INPUT_METHOD_SERVICE);
                    imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0);
                    spinV=v.getText().toString();
                    handled = true;

                }


                return handled;
            }
        });
    }






















    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main_activity2, menu);
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
