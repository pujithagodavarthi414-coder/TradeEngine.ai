using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Hosting.Internal;


namespace DocumentStorageService.Helpers.Constants
{
    public class AppConstants
    {
        public AppConstants()
        {

        }
        public static string LocalBlobContainerReference = "localsiteuploads";
       // public static string UploadFileChunkPath = HostingEnvironment.("~/upload");
        public static string HrmBlobDirectoryReference = "hrm";
        public static string AssetsBlobDirectoryReference = "assets";
        public static string FoodOrderBlobDirectoryReference = "foodorder";
        public static string ProjectsBlobDirectoryReference = "projects";
        public static int InputWithMaxSize1000 = 1000;
    }
}
