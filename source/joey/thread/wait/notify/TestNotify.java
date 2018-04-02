package joey.thread.wait.notify;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by yp-tc-m-7179 on 2018/2/26.
 *
 */
public class TestNotify {
    private static class Job{
        int i;
        Job(){}
        Job(int i){
            this.i = i;
        }
        @Override
        public String toString() {
            return "job:"+i;
        }
    }
    static List<Job> jobs = new ArrayList<>();
    static int i = 0;
    static class JobMaker extends Thread{
        @Override
        public void run() {
            while (true){
                try {
                    Thread.sleep(3000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                synchronized (jobs){
                    Job job = new Job(i++);
                    jobs.add(job);
                    System.out.println(job+" created!");
                    jobs.notifyAll(); //会报错！！！！
//                    jobs.notify();
                }
            }
        }
    }

    static class Worker extends Thread{
        private String name;
        Worker(){}
        Worker(String name){
            this.name = name;
        }
        @Override
        public void run() {
            while (true){
                synchronized (jobs){
                    if (jobs.size()==0){
                        try {
                            jobs.wait();
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                    Job job = jobs.get(0);
                    jobs.remove(0);
                    System.out.println(job+" worked by "+name);
                }
            }
        }
    }

    public static void main(String[] args) {
        System.out.println("start...");
        JobMaker jobMaker = new JobMaker();
        jobMaker.start();
        Worker workera = new Worker("a");
        Worker workerb = new Worker("b");
        workera.start();
        workerb.start();
    }

}
