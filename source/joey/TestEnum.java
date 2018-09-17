package joey;

/**
 * Created by yp-tc-m-7179 on 2018/9/13.
 */
public enum TestEnum {
    TEST("sdfadsf"){
        public void soutTest(){
            System.out.println(getName());
        }
    };

    private String name;

    TestEnum(String name) {
        this.name = name;
    }

    abstract void soutTest();
    public static void main(String[] args) {
        TestEnum.TEST.soutTest();
    }

    public String getName() {
        return this.name;
    }
}
