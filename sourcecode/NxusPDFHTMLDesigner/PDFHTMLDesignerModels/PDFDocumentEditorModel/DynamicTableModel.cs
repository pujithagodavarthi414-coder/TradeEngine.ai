using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerModels.PDFDocumentEditorModel
{
    public class DynamicTableModel
    {
        public List<string> tableHeaders { get; set; }
        public List<object> tableBody { get; set; }
    }
}
