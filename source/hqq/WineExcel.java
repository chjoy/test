package hqq;

import cn.afterturn.easypoi.excel.ExcelImportUtil;
import cn.afterturn.easypoi.excel.entity.ImportParams;

import java.io.File;

/**
 * Created by yp-tc-m-7179 on 2018/4/18.
 *
 */
public class WineExcel {
    public static void main(String[] args) {
        ImportParams importParams = new ImportParams();
        ExcelImportUtil.importExcel(new File("/Users/yp-tc-m-7179/Downloads/单位汇总412.xls"),Object.class,importParams);

    }
}
