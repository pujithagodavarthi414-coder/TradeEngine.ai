using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels
{
    public class ValidationMessage
    {
        public string Field { get; set; }
        public string ValidationMessaage { get; set; }
        public MessageTypeEnum ValidationMessageType { get; set; }

        public override string ToString()
        {
            return ValidationMessageType + ":" + ValidationMessaage;
        }
    }
}
