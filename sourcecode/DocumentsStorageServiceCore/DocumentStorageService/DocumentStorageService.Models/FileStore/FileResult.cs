using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class FileResult
    {
        public string FileUrl { get; set; }
        public string FileName { get; set; }
        public long? FileSize { get; set; }
        public string FilePath { get; set; }
        public string LocalFilePath { get; set; }
        public string FileExtension { get; set; }

    }
}
