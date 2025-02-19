package com.example.asset_tracking;

import static com.example.asset_tracking.tools.StringUtils.isEmpty;
import static com.example.asset_tracking.tools.StringUtils.isNotEmpty;

import android.content.Context;
import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.PersistableBundle;
import android.os.PowerManager;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.example.asset_tracking.tools.UIHelper;
import com.example.asset_tracking.tools.htfClasses.UhfInfo;
import com.example.asset_tracking.tools.htfClasses.UtfCallbacks;
import com.rscja.deviceapi.RFIDWithUHFUART;
import com.rscja.deviceapi.entity.UHFTAGInfo;
import com.soten.libs.base.MessageResult;
import com.soten.libs.uhf.UHFManager;
import com.soten.libs.uhf.UHFResult;
import com.soten.libs.uhf.base.CMD;
import com.soten.libs.uhf.base.ResultBundle;
import com.soten.libs.uhf.impl.UHF;
import com.soten.libs.uhf.impl.UHFModelListener;
import com.soten.libs.utils.PowerManagerUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;
import java.util.Timer;
import java.util.TimerTask;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity implements MethodChannel.MethodCallHandler, UHFModelListener,Handler.Callback {

    private Context context;
    public RFIDWithUHFUART mReader;
    private static final String TAG = "UHFReadClass";
    private int inventoryFlag = 0;
    public static List<String> tempDatas = new ArrayList<>();

    public static HashMap<String, String> map;
    public static ArrayList<String> epcTidUser = new ArrayList<>();
    public static UhfInfo uhfInfo=new UhfInfo();
    public static ArrayList<HashMap<String, String>> tagList = new ArrayList<HashMap<String, String>>();;
    private int total;
    private long time;

    public static final String TAG_EPC = "tagEPC";
    public static final String TAG_EPC_TID = "tagEpcTID";
    public static final String TAG_COUNT = "tagCount";
    public static final String TAG_RSSI = "tagRssi";
    HashMap<Integer, Integer> soundMap = new HashMap<Integer, Integer>();
    private SoundPool soundPool;

    private AudioManager am;
    private float volumnRatio;
    UtfCallbacks callback;
    String channelName = "utfCode";
    private MethodChannel methodChannel;

    //------------------Yellow Scanner------------------------/
    private UHFManager mUHFManager;
    private UHF uhf;
    private Timer timer;
    private Handler mHandler;
    private int count;
    private int receice;

    //------------------Yellow end--------------------------//

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        methodChannel = new MethodChannel(Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(), channelName);
        context = this;
        context = this;
        initUHF();
        initSound();
        // UHFReadCallback(tagList -> {
        //     for (int i =0; i<tagList.size(); i++){
        //         Toast.makeText(context, tagList.get(i).get(TAG_EPC_TID) +"  "+ tagList.get(i).get(TAG_COUNT) +"  "+ tagList.get(i).get(TAG_RSSI), Toast.LENGTH_SHORT).show();
        //         sendMessageToFlutter(tagList.get(i).get(TAG_EPC_TID));
        //     }
        // });
         UHFReadCallback((UFTCode, Rssi, UtfCount) -> {
          //  Toast.makeText(context, UFTCode + " "+ Rssi+ " "+UtfCount, Toast.LENGTH_SHORT).show();
            sendMessageToFlutter(UFTCode);
        });

         //-----------------Yellow-------------//


        mHandler = new Handler(this);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), channelName)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("sendActionToNative")) {
                        String action = call.argument("action");
                        startScanTag();
                        // Handle the action here
                        // Example: Call a method in your native code
                        // YourNativeClass.handleAction(action);
                        result.success(null);
                    } else {
                        result.notImplemented();
                    }
                });

    }

    private void startScanTag(){
        Log.e("Testing","1");
        mUHFManager = UHFManager.getInstance();
        Log.e("Testing","2");
        uhf = mUHFManager.getUHF();
        Log.e("Testing","3");
        PowerManager pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
        Log.e("Testing","4");
        PowerManagerUtils.open(pm, 0x0C);
        Log.e("Testing","5");
        mUHFManager.open(context);
        Log.e("Testing","6");
        boolean register = mUHFManager.register(this);
        Log.e("Testing","7");
        System.out.println("register " + register);
        Log.e("Testing","8");
        scanTag();
    }

    private void stopScanTag(){
        stopScan();
        boolean unregister = mUHFManager.unregister(this);
        System.out.println("unregister " + unregister);
        mUHFManager.close(uhf, this);
    }
    private void stopScan() {
        if (!mUHFManager.isOpen()) {
           // Toast.makeText(context, "Please turn on UHF and scan again", Toast.LENGTH_SHORT).show();
            return;
        }
        timer.cancel();
        System.out.println("count " + count);
        timer = null;
    }

    private void scanTag() {
        if (!mUHFManager.isOpen()) {
          //  Toast.makeText(context, "Please turn on UHF and scan again", Toast.LENGTH_SHORT).show();
            return;
        }
        if (null == timer) {
            timer = new Timer();
            count = 0;
            receice = 0;
            timer.schedule(new TimerTask() {

                @Override
                public void run() {
                    uhf.realTimeInventory();
                    count++;
                }
            }, 0, 100);
        }
    }

    @Override
    public void onReceice(MessageResult result) {

        UHFResult uhfResult = (UHFResult) result;
        Bundle bundle = uhfResult.getBundle();
        int cmd = bundle.getInt(ResultBundle.CMD);
        switch (cmd) {
            case CMD.GET_FIRMWARE_VERSION:
                int major = bundle.getInt(ResultBundle.MAJOR);
                int minor = bundle.getInt(ResultBundle.MINOR);
                StringBuilder builder = new StringBuilder();
                builder.append("major=");
                builder.append(major);
                builder.append("minor=");
                builder.append(minor);
                System.out.println("major " + major + ",minor " + minor);
                break;
            case CMD.REAL_TIME_INVENTORY:
                receice++;
                int ANT_ID = bundle.getInt(ResultBundle.ANT_ID);
                int READ_RATE = bundle.getInt(ResultBundle.READ_RATE);
                int TOTAL_READ = bundle.getInt(ResultBundle.TOTAL_READ);

                double FREQUENCY = bundle.getDouble(ResultBundle.FREQUENCY);
                String EPC = bundle.getString(ResultBundle.EPC);
                String PC = bundle.getString(ResultBundle.PC);
                int RSSI = bundle.getInt(ResultBundle.RSSI);

                builder = new StringBuilder();
                if (EPC != null) {
                    Log.e("EPC=", EPC);
                    MainActivity.this.runOnUiThread(() -> sendMessageToFlutter(EPC));
                    builder.append("EPC=" + EPC);
                    System.out.print("ANT_ID " + ANT_ID);
                    System.out.print(",READ_RATE " + READ_RATE);
                    System.out.print(",TOTAL_READ " + TOTAL_READ);
                    System.out.print(",FREQUENCY " + FREQUENCY);
                    System.out.print(",EPC " + EPC);
                    System.out.print(",PC " + PC);
                    System.out.print(",RSSI " + RSSI);
                    System.out.println(",receice " + receice);
                }
                break;
            case CMD.READ_TAG:
                byte[] data = bundle.getByteArray(ResultBundle.DATA);
                System.out.println(bundle.toString());
                if (null != data && data.length > 0) {
                    System.out.println(" data " + new String(data));
                    builder = new StringBuilder();
                    builder.append("data=" + data);
                }

            default:
                break;
        }
        mHandler.obtainMessage(0x00).sendToTarget();

    }

    @Override
    public boolean handleMessage(@NonNull Message message) {
        if (message.obj != null) {
            Log.e("message.obj", message.obj.toString());
            System.out.println("update");
        }
        return false;
    }

    @Override
    public void onLostConnect(Exception e) {
        System.out.println("onLostConnect");
    }


    //-----------------Yellow---------------//
    private void sendMessageToFlutter(String message) {
        methodChannel.invokeMethod("receiveData", message);
        if (mUHFManager != null) {
            stopScanTag();
        }
    }
    public void initUHF() {
        try {
            mReader = RFIDWithUHFUART.getInstance();

        } catch (Exception ex) {
            Toast.makeText(context,ex.getMessage(),Toast.LENGTH_SHORT).show();

            return;
        }

        if (mReader != null) {
            mReader.init();
        }
    }
    void UHFReadCallback(UtfCallbacks callback){
        this.callback = callback;
    }
    private void initSound() {
        soundPool = new SoundPool(10, AudioManager.STREAM_MUSIC, 5);
       //soundMap.put(1, soundPool.load(context, R.raw.barcodebeep, 1));
       //soundMap.put(2, soundPool.load(context, R.raw.serror, 1));
        am = (AudioManager) context.getSystemService(AUDIO_SERVICE);// 实例化AudioManager对象
    }

    void startReadTagSingle(){
        inventoryFlag = 0;
        time = System.currentTimeMillis();
        UHFTAGInfo uhftagInfo = mReader.inventorySingleTag();
        if (uhftagInfo != null) {
            String tid = uhftagInfo.getTid();
            String epc = uhftagInfo.getEPC();
            String user=uhftagInfo.getUser();
            addDataToList(epc,mergeTidEpc(tid, epc, user), uhftagInfo.getRssi());
            playSound(1);
        } else {
           UIHelper.ToastMessage(context, "Failed To Scan Tag Try Again...");
        }
    }

    public void playSound(int id) {
        float audioMaxVolume = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC); // 返回当前AudioManager对象的最大音量值
        float audioCurrentVolume = am.getStreamVolume(AudioManager.STREAM_MUSIC);// 返回当前AudioManager对象的音量值
        volumnRatio = audioCurrentVolume / audioMaxVolume;
        try {
            soundPool.play(soundMap.get(id), volumnRatio, // 左声道音量
                    volumnRatio, // 右声道音量
                    1, // 优先级，0为最低
                    0, // 循环次数，0不循环，-1永远循环
                    1 // 回放速度 ，该值在0.5-2.0之间，1为正常速度
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void releaseSoundPool() {
        if(soundPool != null) {
            soundPool.release();
            soundPool = null;
        }
    }

    @Override
    protected void onDestroy() {
        if (null != timer)
            timer.cancel();
        super.onDestroy();
        releaseSoundPool();
        boolean unregister = mUHFManager.unregister(this);
        System.out.println("unregister " + unregister);
        mUHFManager.close(uhf, this);
    }

    private String mergeTidEpc(String tid, String epc,String user) {
        epcTidUser.add(epc);
        String data="EPC:"+ epc;
        if (!TextUtils.isEmpty(tid) && !tid.equals("0000000000000000") && !tid.equals("000000000000000000000000")) {
            epcTidUser.add(tid);
            data+= "\nTID:" + tid ;
        }
        if(user!=null && user.length()>0) {
            epcTidUser.add(user);
            data+="\nUSER:"+user;
        }
        return  data;
    }

    public int checkIsExist(String epc) {
        if (isEmpty(epc)) {
            return -1;
        }
        for(int k=0;k<tempDatas.size();k++){
            if(epc.equals(tempDatas.get(k))){
                return k;
            }
        }
        return -1;
    }
    private void addDataToList(String epc,String epcAndTidUser, String rssi) {
        if (isNotEmpty(epc)) {
            int index = checkIsExist(epc);
            map = new HashMap<String, String>();
            map.put(TAG_EPC, epc);
            map.put(TAG_EPC_TID, epcAndTidUser);
            map.put(TAG_COUNT, String.valueOf(1));
            map.put(TAG_RSSI, rssi);
            if (index == -1) {
                tagList.add(map);
                tempDatas.add(epc);
            } else {
                int tagCount = Integer.parseInt(tagList.get(index).get(TAG_COUNT), 10) + 1;
                map.put(TAG_COUNT, String.valueOf(tagCount));
                map.put(TAG_EPC_TID, epcAndTidUser);
                tagList.set(index, map);
            }
            callback.onGetResult(epcAndTidUser,rssi,String.valueOf(1));

            uhfInfo.setTempDatas(tempDatas);
            uhfInfo.setTagList(tagList);
            uhfInfo.setCount(total);
            uhfInfo.setTagNumber(tagList.size());
        }
    }


    @Override
    public boolean dispatchKeyEvent(KeyEvent event) {
        if (event.getAction() == KeyEvent.ACTION_UP){
            if (event.getKeyCode() == KeyEvent.KEYCODE_F9) {
                startReadTagSingle();
               // return true;
                // Add more cases for other keys if needed
            }
        }
        return super.dispatchKeyEvent(event);

    }

    @Override
public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    if (call.method.equals("sendDataToNative")) {
        String data = call.argument("data");
        // Process the data as needed
        processDataFromFlutter(data);
        result.success(null);  // Acknowledge the method call
        Toast.makeText(context, "Yes", Toast.LENGTH_SHORT).show();
    } else {
        result.notImplemented();
        Toast.makeText(context, "No", Toast.LENGTH_SHORT).show();
    }
}

private void processDataFromFlutter(String data) {
    Toast.makeText(context, data, Toast.LENGTH_SHORT).show();
}
}
