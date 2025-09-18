using System;
using System.Text;

namespace Btrak.Models.DocumentManagement
{
    public class SearchFoldersAndFilesReturnModel
    {
        public string Folders { get; set; }
        public string Files { get; set; }
        public bool IsDefault { get; set; }
        

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("Folders = " + Folders);
            stringBuilder.Append("Files = " + Files);
            stringBuilder.Append("IsDefault = " + IsDefault);
            return stringBuilder.ToString();
        }
    }
}
