package joey.thread.deamon;

/**
 * Created by yp-tc-m-7179 on 2018/3/9.
 * 守护线程在主线程退出后，直接被stop
 */
public class TestDeamon {
    static class TestThread extends Thread{
        TestThread(String name){
            setName(name);
        }
        @Override
        public void run() {
            System.out.println(Thread.currentThread().getName()+" running!");
            try {
                Thread.sleep(5000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("over");
        }
    }

    public static void main(String[] args) throws Exception{
        Thread t1 = new TestThread("t1");
        t1.setDaemon(true);
        t1.start();
        Thread.sleep(6000);
    }
}
