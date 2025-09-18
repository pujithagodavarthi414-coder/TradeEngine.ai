using BTrak.Common;
using static BTrak.Common.Enumerators;

namespace Btrak.Models.File
{
    public class FileSystemConfigModel
    {
        public FileSystemType FileSystemTypeEnum { get; set; }
        public string LocalFileBasePath { get; set; }
        public string CompanyName { get; set; }
        public string EnvironmenName { get; set; }
        public int ModuleTypeId { get; set; }
        public string ModuleType
        {
            get
            {
                return ModuleTypeId == (int)ModuleTypeEnum.Hrm ? AppConstants.HrmBlobDirectoryReference :
                 ModuleTypeId == (int)ModuleTypeEnum.Assets ? AppConstants.AssetsBlobDirectoryReference :
                 ModuleTypeId == (int)ModuleTypeEnum.FoodOrder ? AppConstants.FoodOrderBlobDirectoryReference :
                 ModuleTypeId == (int)ModuleTypeEnum.Projects ? AppConstants.ProjectsBlobDirectoryReference :
                 ModuleTypeId == (int)ModuleTypeEnum.Cron ? AppConstants.ProjectsBlobDirectoryReference : AppConstants.LocalBlobContainerReference;
            }
        }
    }
}
