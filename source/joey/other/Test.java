package joey.other;

import java.util.*;

/**
 * Created by yp-tc-m-7179 on 2017/12/11.
 */
public class Test {
    static class Person {
    }



    static class Student extends Person {
    }

    public static void main(String[] args) {
        Vector<String> v = new Vector<String>();
        v.add("aaa");
        v.add("bbb");
        v.add("ccc");
        synchronized (v){
            for (int i = 0; i < v.size(); i++) {
                System.out.println(v.get(i));
            }
        }
    }

}
