using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.File
{
    public class DeleteFileInputModel : InputModelBase
    {
        public DeleteFileInputModel() : base(InputTypeGuidConstants.FileDeleteInputCommandTypeGuid)
        {
        }

        public Guid? FileId { get; set; }
        public Guid? ReferenceId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" FileId = " + FileId);
            return stringBuilder.ToString();
        }
    }
}