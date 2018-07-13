package joey.other;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by yp-tc-m-7179 on 2017/12/11.
 *
 */
public class Test {
    static class Person{}
    static class Student extends Person{}
    public static void main(String[] args) {
        List<String> list0 = Arrays.asList("abc");
        ArrayList<String> list = new ArrayList<String>();
        list.add("aaa");
        list.add("bbb");
        list.add("ccc");
        list.add("ddd");
        ArrayList<String> list1 = new ArrayList<String>(list);
        ArrayList<String> list2 = new ArrayList<String>(list0);
        System.out.println(list0.getClass());
        System.out.println(list.getClass());
        System.out.println(list1.getClass());
    }

}
