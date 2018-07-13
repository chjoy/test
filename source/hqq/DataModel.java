package hqq;

import cn.afterturn.easypoi.excel.annotation.Excel;

/**
 * Created by yp-tc-m-7179 on 2018/4/18.
 *
 */
public class DataModel {

    @Excel(name = "企业名称", orderNum = "1", width = 25)
    private String orgName;
}
