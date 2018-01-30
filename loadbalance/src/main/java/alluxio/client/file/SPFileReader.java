package alluxio.client.file;

import alluxio.AlluxioURI;
import alluxio.client.ReadType;
import alluxio.client.file.options.OpenFileOptions;
import alluxio.exception.AlluxioException;
import alluxio.util.CommonUtils;

import java.io.IOException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

/**
 * Created by renfei on 2017/11/24.
 *
 * This class reads the file in parallel from k machines and assemble them into a single buffer.
 */
public class SPFileReader {

    private int mK;
    private FileSystem mFileSystem;
    private AlluxioURI mFilePath;
    private OpenFileOptions mReadOptions;


    public SPFileReader(FileSystem fileSystem, AlluxioURI filePath) throws IOException, AlluxioException {
        mFileSystem = fileSystem;
        mFilePath = filePath;
        mReadOptions = OpenFileOptions.defaults().setReadType(ReadType.NO_CACHE);
        mReadOptions.setForSP(true);
        mK = mFileSystem.getStatus(filePath).getKValueForSP();
    }

    public void setReadOption(OpenFileOptions readOptions) {
        mReadOptions = readOptions;
    }

    public long runRead() throws Exception {
        // Initialize a buffer for reading
        FileInStream is = mFileSystem.openFile(mFilePath, mReadOptions);
        byte[] fileBuf = new byte[(int) is.mFileLength];

        ExecutorService executorService = Executors.newCachedThreadPool();

        final long startTimeMs = CommonUtils.getCurrentMs();
        for (int i = 0; i < mK; i++) {
            executorService.execute(new ReadBlockThread(fileBuf, mFilePath, mFileSystem, mReadOptions, i));
        }

        executorService.shutdown();
        try {
            executorService.awaitTermination(1, TimeUnit.HOURS);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        // Thread.sleep(5000L); //debug
        final long endTimeMs = CommonUtils.getCurrentMs();
        return endTimeMs - startTimeMs;
    }

}
