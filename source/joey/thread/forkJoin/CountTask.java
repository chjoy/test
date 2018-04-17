package joey.thread.forkJoin;

import java.util.ArrayList;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.ForkJoinTask;
import java.util.concurrent.RecursiveTask;

/**
 * Created by yp-tc-m-7179 on 2018/4/13.
 * 本例子是从书上摘下来的，但是运行有问题，可能另外弄个forkjoin的连接池测试
 * 至于该例子为何无法运行，可以抽时间研究研究
 */
public class CountTask extends RecursiveTask{

    private static final int THRESHOLD = 10000;
    private long start;
    private long end;

    public CountTask(long start, long end) {
        this.start = start;
        this.end = end;
    }

    @Override
    protected Long compute() {
        long sum = 0;
        if (end-start<THRESHOLD){
            for (long i = start; i<=end; i++){
                sum += i;
            }
        }else {
            long step = (end+start)/100;
            ArrayList<CountTask> subtasks = new ArrayList<CountTask>();
            long pos = start;
            for (int i = 0; i < 100; i++) {
                long lastOne = pos+step;
                if (lastOne>end)
                    lastOne=end;
                CountTask subTask = new CountTask(pos,lastOne);
                pos+=step+1;
                subtasks.add(subTask);
                subTask.fork();
            }
            for (CountTask subtask : subtasks) {
                sum += (long)subtask.join();//书中没有强转
            }
        }
        return sum;
    }

    public static void main(String[] args) {
        ForkJoinPool forkJoinPool = new ForkJoinPool();
        CountTask task = new CountTask(10000,20001);
        ForkJoinTask<Long> result = forkJoinPool.submit(task);
        try {
            Long r = result.get();
            System.out.println(r);
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
    }
}
