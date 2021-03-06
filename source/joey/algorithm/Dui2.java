package joey.algorithm;

import java.util.Arrays;

/**
 * Created by yp-tc-m-7179 on 2019/8/9.
 * 堆排序
 * 根据Dui1改写后
 */
public class Dui2 {
    public static void main(String []args){
        int []arr = Data.arr;
        sort(arr);
        System.out.println(Arrays.toString(arr));
    }
    public static void sort(int []arr){
        //1.构建大顶堆
        for(int i=arr.length/2-1;i>=0;i--){
            //从第一个非叶子结点从下至上，从右至左调整结构
            adjustHeap(arr,i,arr.length);
        }
        //2.调整堆结构+交换堆顶元素与末尾元素
        for(int j=arr.length-1;j>0;j--){
            swap(arr,0,j);//将堆顶元素与末尾元素进行交换
            adjustHeap(arr,j/2-1,j);//重新对堆进行调整
        }

    }

    /**
     * 调整大顶堆（仅是调整过程，建立在大顶堆已构建的基础上）
     * @param arr
     * @param i
     * @param length
     */
    public static void adjustHeap(int []arr,int i,int length){
        for(;i>=0;i--){//从i结点的左子结点开始，也就是2i+1处开始
            int k=i*2+1;
            if(k+1<length && arr[k]<arr[k+1]){//如果左子结点小于右子结点，k指向右子结点
                k++;
            }
            if(arr[k] >arr[i]){//如果子节点大于父节点，将子节点值赋给父节点（不用进行交换）
                swap(arr,i ,k);
            }
        }
    }

    /**
     * 交换元素
     * @param arr
     * @param a
     * @param b
     */
    public static void swap(int []arr,int a ,int b){
        int temp=arr[a];
        arr[a] = arr[b];
        arr[b] = temp;
    }
}
