package joey.algorithm;

import java.util.Arrays;

/**
 * Created by yp-tc-m-7179 on 2019/7/1.
 *  冒泡排序
 1比较相邻的元素。如果第一个比第二个大，就交换它们两个；
 2对每一对相邻元素作同样的工作，从开始第一对到结尾的最后一对，这样在最后的元素应该会是最大的数；
 3针对所有的元素重复以上的步骤，除了最后一个；
 4重复步骤1~3，直到排序完成
 */
public class MaoPao {

    public static void main(String[] args) {
        int[] arr = Data.arr;
        for (int i = 0; i < arr.length - 1; i++) {
            for (int j = 0; j < arr.length - 1 - i; j++) {
                if (arr[j] > arr[j + 1]) {
                    int temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                }
            }

        }
        System.out.println(Arrays.toString(arr));
    }


}
