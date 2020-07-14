
package com.azureblobstorage;
import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

import android.content.Context;
import android.net.Uri;
import android.os.Handler;
import android.widget.Toast;

import java.io.InputStream;

public class EAzureBlobStorageFile extends ReactContextBaseJavaModule{
    private static final String E_LAYOUT_ERROR = "E_LAYOUT_ERROR";
    private static final String MODULE_NAME = "EAzureBlobStorageFile";

    public static String ACCOUNT_NAME = "";
    public static String ACCOUNT_KEY = "";
    public static String CONTAINER_NAME = "";
    private Context ctx;

    public EAzureBlobStorageFile(@NonNull ReactApplicationContext reactContext) {
        super(reactContext);
        ctx = reactContext;
    }


    @Override
    public String getName() {
        return MODULE_NAME;
    }

    @ReactMethod
    public void uploadFile(ReadableMap options, final Promise promise){

        final String name = options.hasKey("fileName") ? options.getString("fileName") : null;
        String filePath = options.hasKey("filePath") ? options.getString("filePath") : null;
        final String contentType = options.hasKey("contentType") ? options.getString("contentType") : null;

        try {
            String file = filePath.contains("file://") ? filePath : "file://".concat(filePath);
            final InputStream imageStream = ctx.getContentResolver().openInputStream(Uri.parse(file));
            final int imageLength = imageStream.available();

            final Handler handler = new Handler();

            Thread th = new Thread(new Runnable() {
                public void run() {

                    try {

                        final String imageName = FileManager.UploadFile(imageStream, imageLength,name, contentType );


                        handler.post(new Runnable() {

                            public void run() {
                                Toast.makeText(ctx, "Image Uploaded Successfully...", Toast.LENGTH_SHORT).show();
                                promise.resolve(imageName);
                            }
                        });
                    }
                    catch(final Exception ex) {
                        final String exceptionMessage = ex.getMessage();
                        handler.post(new Runnable() {
                            public void run() {
                                Toast.makeText(ctx, exceptionMessage, Toast.LENGTH_SHORT).show();
                                promise.reject(E_LAYOUT_ERROR, ex);
                            }
                        });
                    }
                }});
            th.start();
        }
        catch(Exception ex) {
            Toast.makeText(ctx, ex.getMessage(), Toast.LENGTH_SHORT).show();
            promise.reject(E_LAYOUT_ERROR, ex);
        }
    }

    @ReactMethod
    public void configure(String account_name, String account_key, String constainer_name ){
        this.ACCOUNT_NAME = account_name;
        this.ACCOUNT_KEY = account_key;
        this.CONTAINER_NAME = constainer_name;
    }
}