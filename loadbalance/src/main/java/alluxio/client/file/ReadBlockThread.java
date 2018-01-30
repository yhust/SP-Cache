package alluxio.client.file;

import alluxio.AlluxioURI;
import alluxio.client.file.options.OpenFileOptions;
import alluxio.exception.AlluxioException;
import alluxio.util.CommonUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Created by renfei on 2017/11/24.
 *
 * This class reads a single block into a part of a buffer.
 */
public class ReadBlockThread implements Runnable {

    private FileSystem mFileSystem;
    private AlluxioURI mFilePath;
    private OpenFileOptions mReadOptions;
    private int mPartID;
    private static final Logger LOG = LoggerFactory.getLogger(ReadBlockThread.class);
    private byte[] mBlockBuf;


    public ReadBlockThread(byte[] buf, AlluxioURI filePath, FileSystem fileSystem,
                           OpenFileOptions readOption, int partID) {
        mBlockBuf = buf;
        mPartID = partID;
        mFileSystem = fileSystem;
        mFilePath = filePath;
        mReadOptions = readOption;
    }


    public void run() {

        try {
            final long startTimeMs = CommonUtils.getCurrentMs();
            mReadOptions.setForSP(false);
            FileInStream is = mFileSystem.openFile(mFilePath, mReadOptions);
            long tOffset = mPartID * is.mBlockSize;
            // Seek into the file to the right position.
            is.seek(tOffset);

            // Find the real block size as the last block may not be full;
            long tBlockSize = is.mBlockSize;
            if ((is.mFileLength - is.mPos) < tBlockSize) {
                tBlockSize = is.mFileLength - is.mPos;
            }
            // Read the block into the corresponding position in the buffer.
            int tBytesRead = is.read(mBlockBuf, (int) tOffset, (int) tBlockSize);
            LOG.info("Read a block with size:" + tBytesRead);
            is.close();
            long finishTimeMs = CommonUtils.getCurrentMs();
            LOG.info("Read block No." + mPartID + "with time (MS):" + (finishTimeMs - startTimeMs));

        } catch (AlluxioException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
}
