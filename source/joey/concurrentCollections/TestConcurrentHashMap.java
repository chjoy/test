package joey.concurrentCollections;

import java.util.concurrent.ConcurrentHashMap;

/**
 * Created by yp-tc-m-7179 on 2018/8/31.
 *
 */
public class TestConcurrentHashMap {
    public static void main(String[] args) {
        ConcurrentHashMap map = new ConcurrentHashMap();
        map.put("a","a");
        map.put("a","b");
    }
}
