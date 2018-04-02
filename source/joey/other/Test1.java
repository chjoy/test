package joey.other;

import java.util.*;

/**
 * Created by yp-tc-m-7179 on 2017/12/11.
 *
 */
public class Test1 {

    public static void main(String[] args) {
        Map map = new HashMap();
        map.put("a","b");
        map.put(101,"c");
        for (int i = 0; i < 17; i++) {
            if (i>9)
                System.out.println(111);
            map.put(i,i+1);
        }
    }
}
