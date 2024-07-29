package com.linkid.flutter_linkid_gami;

import android.app.Activity;
import com.linkid.gami.GamePlayActivity;

public class MyGame extends GamePlayActivity {
    @Override
    public void onEventTracking(String s) {
        FlutterLinkidGamiPlugin.getInstance().onEventTracking(s);
    }
}
