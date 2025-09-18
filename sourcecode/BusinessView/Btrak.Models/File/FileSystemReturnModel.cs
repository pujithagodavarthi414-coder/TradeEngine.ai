using static BTrak.Common.Enumerators;

namespace Btrak.Models.File
{
    public class FileSystemReturnModel
    {
        public FileSystemType FileSystemTypeEnum { get; set; }
        public string BlobFilePath { get; set; }
        public string LocalFilePath { get; set; }
    }
}
