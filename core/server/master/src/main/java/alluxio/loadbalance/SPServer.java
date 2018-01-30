package alluxio.loadbalance;
import alluxio.AlluxioURI;


import java.io.FileWriter;
import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Created by yyuau on 25/12/2017.
 */
public class SPServer {
    ConcurrentHashMap<AlluxioURI, Long> mAccessHistory = new ConcurrentHashMap<>(); // thread safe
    public boolean changeFlag = false; //  Avoid duplicate logging: set this flag when the accessHistory has been changed.
    // Only output the history when the flag is set.

    // private Long mTotalCount;
    // private Long mThreshold = 10L;
    String mLog;
    private SPMasterLogger mLogger;
    private Timer mTimer = new Timer();


    public SPServer() {
        // mTotalCount = 0L; // log the access history every mThreshold accesses
        mTimer = new Timer();
        mLogger = new SPMasterLogger(this);
        mTimer.schedule(mLogger, 0, 10000); // log the access history every 10 secs
        String logDirPath = System.getProperty("user.dir") + "/logs";
        File LogDir = new File(logDirPath);
        if (!LogDir.exists()){
            LogDir.mkdir();
        }
        mLog = logDirPath + "/SPServer.txt"; // log the popularity
        System.out.println("File path is" + mLog);
    }

    public void onAccess(AlluxioURI alluxioURI) {
        // mTotalCount += 1;
        mAccessHistory.putIfAbsent(alluxioURI, 0L); // atomic operation
        mAccessHistory.put(alluxioURI, mAccessHistory.get(alluxioURI)+1);
        if(!changeFlag) {
            changeFlag = true;
        }

        /* the if-else statement is not atomic
        if (mAccessHistory.containsKey(alluxioURI)) {
            mAccessHistory.put(alluxioURI, mAccessHistory.get(alluxioURI)+1);
        }
        else
            mAccessHistory.put(alluxioURI, 1L);
        // if(mTotalCount % mThreshold == 0) {
           // doLog();
        // }
         */
    }

    public void onCreate(AlluxioURI alluxioURI) {
        mAccessHistory.put(alluxioURI, 0L);
    }

}


class SPMasterLogger extends TimerTask {

    private SPServer mSPServer;

    SPMasterLogger(SPServer spServer) {
        mSPServer = spServer;
    }


    public void run() { // periodically log the access counts
        if(!mSPServer.changeFlag){
            // System.out.print("Nothing changed");
            return;
        }
        else{
            System.out.print("Flag set \n" + mSPServer.changeFlag);
            Iterator it = mSPServer.mAccessHistory.entrySet().iterator();
            FileWriter fw = null;
            try {
                fw = new FileWriter(mSPServer.mLog, true); //the true will append the new data
//            fw.write("Entry: \n");
                while (it.hasNext()) {
                    Map.Entry pair = (Map.Entry) it.next();
                    fw.write(pair.getKey() + " = " + pair.getValue() + "\n");
                    // it.remove(); // avoids a ConcurrentModificationException
                }
                fw.write("\n");
                fw.close();
            } catch (IOException e){
                e.printStackTrace();
            }finally {
                try {
                    fw.close();
                }
                catch (IOException e){
                    e.printStackTrace();
                }
            }
            mSPServer.changeFlag =false; // reset the flag
        }

    }

}


