
using System;
using System.Text;

namespace Btrak.Models.File
{
    public class FileResult
    {
        public string FileUrl { get; set; }
        public string Url { get; set; }
        public string FileName { get; set; }
        public string Name { get; set; }
        public long? FileSize { get; set; }
        public long? Size { get; set; }
        public string FilePath { get; set; }
        public string LocalFilePath { get; set; }
        public string FileExtension { get; set; }
        public Guid? FileId { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", FileName= " + FileName);
            stringBuilder.Append(", FileSize= " + FileSize);
            stringBuilder.Append(", FilePath= " + FilePath);
            stringBuilder.Append(", LocalFilePath= " + LocalFilePath);
            stringBuilder.Append(", FileExtension= " + FileExtension);

            return stringBuilder.ToString();

        }
    }
}