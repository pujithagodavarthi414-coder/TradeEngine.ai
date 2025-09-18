using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.CustomApplication
{
    public class ObservationTypeModel
    {
        public Guid? ObservationTypeId { get; set; }

        public string ObservationTypeName { get; set; }

        public bool IsArchived { get; set; }

        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ObservationTypeId = " + ObservationTypeId);
            stringBuilder.Append(", ObservationTypeName = " + ObservationTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
