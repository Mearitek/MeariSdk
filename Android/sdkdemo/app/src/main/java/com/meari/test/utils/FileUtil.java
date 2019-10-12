package com.meari.test.utils;

import java.io.File;

public class FileUtil {
	public static boolean fileIsExists(String url){
        try{
                File f=new File(url);
                if(!f.exists()){
                        return false;
                }
        }catch (Exception e) {
                // TODO: handle exception
                return false;
        }
        return true;
}
}
