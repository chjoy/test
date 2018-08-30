package joey.thread.countDownLatch;

import java.util.Set;
import java.util.concurrent.*;

/**
 * 假设现在需要计算3个学生的平均成绩,
 *每个学生共有三门成绩
 *步骤是:先计算出每个学生的平均成绩
 *再根据每个学生的平均成绩来计算所有有同学的平均成绩
 *使用CountDownLatch
 * @author Administrator
 *
 */
public class CountDownLatch1{

    //创建初始化3个线程的线程池
    private ExecutorService threadPool=Executors.newFixedThreadPool(3);
    //创建3个CyclicBarrier对象,执行完后执行当前类的run方法
    private CountDownLatch countDownLatch=new CountDownLatch(3);
    //保存每个学生的平均成绩
    private ConcurrentHashMap<String, Integer> map=new ConcurrentHashMap<String,Integer>();

    public void count(){
        for(int i=0;i<3;i++){
            threadPool.execute(new Runnable(){

                @Override
                public void run() {
                    //计算每个学生的平均成绩,代码略()假设为60~100的随机数
                    int score=(int)(Math.random()*40+60);
                    map.put(Thread.currentThread().getName(), score);
                    System.out.println(Thread.currentThread().getName()+"同学的平均成绩为"+score);
                    try {
                        //执行完运行await(),等待所有学生平均成绩都计算完毕
                        countDownLatch.countDown();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }

            });
        }
        try {
            countDownLatch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        int result=0;
        Set<String> set = map.keySet();
        for(String s:set){
            result+=map.get(s);

        }
        System.out.println("三人平均成绩为:"+(result/3)+"分");
    }


    public static void main(String[] args) {
        CountDownLatch1 cb=new CountDownLatch1();
        cb.count();
    }
}