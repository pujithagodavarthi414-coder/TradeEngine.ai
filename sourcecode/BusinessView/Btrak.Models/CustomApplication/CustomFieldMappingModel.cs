using System;
using System.Collections.Generic;

namespace Btrak.Models.CustomApplication
{
    public class sheets
    {
        public string sheetName { get; set; }
        public Guid? formId { get; set; }
        public List<keyvalues> formHeaders { get; set; }
    }

    public class keyvalues
    {
        public string formHeader { get; set; }
        public string excelHeader { get; set; }
        public bool isItGoodToImport { get; set; }
    }
}
