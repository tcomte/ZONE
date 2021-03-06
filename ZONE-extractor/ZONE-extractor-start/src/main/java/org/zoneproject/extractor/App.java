package org.zoneproject.extractor;

/*
 * #%L
 * ZONE-extractor-start
 * %%
 * Copyright (C) 2012 ZONE-project
 * %%
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * #L%
 */

import java.util.Timer;

/**
 *
 * @author Desclaux Christophe <christophe@zouig.org>
 */
public class App {
    
    public static void main(String[] args)  {
       Timer [] timer= new Timer[6];
       for(int i=0; i < 6; i++)
           timer[i] = new Timer();

       String [] apps = new String[6];
       
       apps[0] = "org.zoneproject.extractor.twitterreader.App";
       apps[1] = "org.zoneproject.extractor.rssreader.App";
       apps[2] = "org.zoneproject.extractor.plugin.extractarticlescontent.App";
       apps[3] = "org.zoneproject.extractor.plugin.opencalais.App";
       apps[4] = "org.zoneproject.extractor.plugin.wikimeta.App";
       apps[5] = "org.zoneproject.extractor.plugin.inseegeo.App";
       
       for(int i=0; i< 6;i++)
           timer[i].scheduleAtFixedRate( new ThreadApp(apps[i]),0, 30000);
    }
}
