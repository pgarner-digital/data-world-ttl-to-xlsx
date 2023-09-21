package gov.fl.digital.ddw2infa;

import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Base64;

public class Base64EncoderForAlteryx {

    private static String username = "patrick.garner@dms.fl.gov";
    private static String password = "";

    public static void main(String[] args) {
        String usernameAndPassword = username + ":" + password;
        byte[] usernameAndPasswordBytes = usernameAndPassword.getBytes(StandardCharsets.UTF_8);
        System.out.println(Base64.getEncoder().encode(usernameAndPasswordBytes));
    }
}
