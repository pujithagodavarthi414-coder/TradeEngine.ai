using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models
{
    public class IntroOutputModel
    {
        public Guid? IntroId { get; set; }
        public Guid? ModuleId { get; set; }
        public string EnableIntro { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? UserId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" IntroId = " + IntroId);
            stringBuilder.Append(" ModuleId = " + ModuleId);
            stringBuilder.Append(", EnableIntro = " + EnableIntro);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
