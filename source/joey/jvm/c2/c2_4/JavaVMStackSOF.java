package joey.jvm.c2.c2_4;

/**
 * Created by yp-tc-m-7179 on 2019/5/22.
 * 虚拟机栈和本地方法栈oom测试
 * -Xss128k
 */
public class JavaVMStackSOF {

    private int stackLength = 1;

    public void leak (){
        stackLength ++;
        leak();
    }

    public static void main(String[] args) {
        JavaVMStackSOF test = new JavaVMStackSOF();
        try {
            test.leak();
        } catch (Throwable e) {
            System.out.println(test.stackLength);
            e.printStackTrace();
        }
    }
}
