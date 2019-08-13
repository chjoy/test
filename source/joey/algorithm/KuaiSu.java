package joey.algorithm;

/**
 * Created by yp-tc-m-7179 on 2019/7/30.
 */
public class KuaiSu {
    public static void main(String[] args) {
        int[] arr = Data.arr;
        quicksort(arr, 0, arr.length - 1);
    }

    private static void quicksort(int[] arr, int left, int right) {
        int temp = arr[left];
        while (right > left) {
            if (arr[right] < temp) {
                arr[left] = arr[right];
//                while ()
            }
        }
    }
}
