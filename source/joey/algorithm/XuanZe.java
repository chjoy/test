package joey.algorithm;

import java.util.Arrays;

/**
 * Created by yp-tc-m-7179 on 2019/7/1.
 * 选择排序
 *
 1初始状态：无序区为R[1..n]，有序区为空；
 2第i趟排序(i=1,2,3…n-1)开始时，当前有序区和无序区分别为R[1..i-1]和R(i..n）。该趟排序从当前无序区中-选出关键字最小的记录 R[k]，将它与无序区的第1个记录R交换，使R[1..i]和R[i+1..n)分别变为记录个数增加1个的新有序区和记录个数减少1个的新无序区；
 3n-1趟结束，数组有序化了。
 */
public class XuanZe {
    public static void main(String[] args) {
        int[] arr = Data.arr;
        for (int i = 0; i < arr.length; i++) {
            int min = arr[i];
            for (int j = i; j < arr.length; j++) {
                if (arr[j]<min){
                    int temp = min;
                    min = arr[j];
                    arr[j] = temp;
                }
            }
            arr[i] = min;
        }
        System.out.println(Arrays.toString(arr));
    }
}
