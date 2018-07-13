package joey.lockOptimize.threadLocal;

import java.lang.ref.WeakReference;

/**
 * Created by yp-tc-m-7179 on 2018/5/4.
 *
 */
public class TestWeakReference {
    static class User{

    }
    public static void main(String[] args) {
        User user = new User();
        WeakReference<User> wk = new WeakReference<User>(user);
        int i=0;
        while (true){
            if (wk.get()!=null){
                System.out.println("running");
                i++;
                if (i==1000) System.gc();
            }else {
                System.out.println("bean gced!");
                break;
            }
        }
    }
}
