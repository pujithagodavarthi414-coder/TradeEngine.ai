using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Models.FileStore
{
    public class FileInputModel
    {
        public string FilePath { get; set; }

        public string FileName { get; set; }

        public byte[] FileBytes { get; set; }

        public string FileType { get; set; }

        public Guid? MessageId { get; set; }

        public int ChunkId { get; set; }

        public Guid FileId { get; set; }
    }
}
