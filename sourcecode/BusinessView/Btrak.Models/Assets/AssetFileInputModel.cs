using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Assets
{
    public class AssetFileInputModel : InputModelBase
    {
        public AssetFileInputModel() : base(InputTypeGuidConstants.PrintAssetsInputCommandTypeGuid)
        {
        }

        public Guid? UserId { get; set; }
        public string FileName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserId = " + UserId);
            stringBuilder.Append(", FileName = " + FileName);
            return stringBuilder.ToString();
        }
    }
}
