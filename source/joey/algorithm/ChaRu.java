package joey.algorithm;

import java.util.Arrays;

/**
 * Created by yp-tc-m-7179 on 2019/7/22.
 * 1从第一个元素开始，该元素可以认为已经被排序；
 * 2取出下一个元素，在已经排序的元素序列中从后向前扫描；
 * 3如果该元素（已排序）大于新元素，将该元素移到下一位置；
 * 4重复步骤3，直到找到已排序的元素小于或者等于新元素的位置；
 * 5将新元素插入到该位置后；
 * 6重复步骤2~5。
 */
public class ChaRu {
    public static void main(String[] args) {
        int[] arr = Data.arr;
        for (int i = 0; i < arr.length - 1; i++) {
            int j = i + 1;
            while (j > 0 && arr[j] < arr[j - 1]) {
                int temp = arr[j];
                arr[j] = arr[j - 1];
                arr[j - 1] = temp;
                j--;
            }
        }
        System.out.println(Arrays.toString(arr));
    }
}
