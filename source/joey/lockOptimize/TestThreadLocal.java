package joey.lockOptimize;

import java.util.Random;

/**
 * Created by yp-tc-m-7179 on 2018/4/17.
 * 个人理解：
 * 1.threadlocal并不是解决并发问题的
 * 2.threadlocal用于单线程内，数据的共享：例如controller中set一个值，在service（需要确认controller和service的调用是在一个线程中）
 *  中调用，如果不通过参数传递，那么就可以用threadlocal去存取
 * 3.线程池使用过程中最好记得remove，避免长期保存大的数据导致内存溢出
 */
public class TestThreadLocal implements Runnable{
    TestThreadLocal(){}
    TestThreadLocal(int index){
        this.index = index;
    }
    int index;
    static int num = 10;
    ThreadLocal<Random> tl0 = new ThreadLocal<Random>(){
        @Override
        protected Random initialValue() {
            return super.initialValue();
        }
    };

    @Override
    public void run() {
        System.out.println(tl0.get());
    }

    public static void main(String[] args) {
        for (int i = 0; i < 3; i++) {
            new Thread(new TestThreadLocal(i)).start();
        }
        System.out.println(num);
    }
}
