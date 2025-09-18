using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.File
{
    public class UploadScreenshotInputModel : InputModelBase
    {
        public UploadScreenshotInputModel() : base(InputTypeGuidConstants.UploadScreenshotInputCommandTypeGuid)
        {
        }

        public int moduleTypeId { get; set; }
        public Guid UserId { get; set; }
        public Guid CompanyId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("moduleTypeId = " + moduleTypeId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            return stringBuilder.ToString();
        }
    }
}
