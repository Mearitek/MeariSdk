package com.meari.open.sdk.util;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public class AesUtil {
    private static final String KEY_ALGORITHM = "AES";
    private static final String DEFAULT_CIPHER_ALGORITHM = "AES/ECB/NoPadding";
    private static final Charset DEFAULT_CHARSET = StandardCharsets.UTF_8;

    public static String encrypt(String content, String password) {
        try {
            if (hasEmpty(content,password)){
                return null;
            }
            Cipher cipher = Cipher.getInstance(DEFAULT_CIPHER_ALGORITHM);
            byte[] byteContent = content.getBytes(DEFAULT_CHARSET);
            int mod = byteContent.length % 16;
            if (mod != 0) {
                byteContent = Arrays.copyOf(byteContent, byteContent.length + 16 - mod);
            }
            cipher.init(Cipher.ENCRYPT_MODE, getSecretKey(password));
            return Base64.encode(cipher.doFinal(byteContent));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String decrypt(String content, String password) {
        try {
            if (hasEmpty(content,password)){
                return null;
            }
            Cipher cipher = Cipher.getInstance(DEFAULT_CIPHER_ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, getSecretKey(password));
            return new String(cipher.doFinal(Base64.decode(content)), DEFAULT_CHARSET);
        }catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private static SecretKey getSecretKey(final String password) {
        return new SecretKeySpec(password.getBytes(), KEY_ALGORITHM);
    }

    private static boolean hasEmpty(String... strings) {
        if (strings==null || strings.length<=0) {
            return true;
        }
        for (String str : strings) {
            if (str == null || "".equals(str)) {
                return true;
            }
        }
        return false;
    }
}