package joey;

import java.io.*;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Created by yp-tc-m-7179 on 2018/9/13.
 *
 */
public class Test {

    private static final String rootPath = "/Users/yp-tc-m-7179/Documents/workspace/enterprise-manage-sybank/project/02_数据处理/12106_26_all";


    public static void main(String[] args) {
        String path = rootPath + "/商标信息/";
        String fileName = "bak.txt";
        File file = new File(path,fileName);
        try {
            BufferedWriter bw = new BufferedWriter(new FileWriter(file));
            bw.write("aaaaaa");
            bw.newLine();
            bw.write("bbbbbb");
            bw.flush();
            bw.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
