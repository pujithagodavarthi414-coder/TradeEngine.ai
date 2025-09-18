using System;
using System.Linq;
using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Spreadsheet;

namespace Btrak.Services.Helpers
{
    public static class OpenXmlHelper
    {
        private static SpreadsheetDocument CreateWorkbook(SpreadsheetDocument spreadSheet)
        {
            // create the workbook
            if (spreadSheet.WorkbookPart == null)
                spreadSheet.AddWorkbookPart();

            if (spreadSheet.WorkbookPart.Workbook == null)
                spreadSheet.WorkbookPart.Workbook = new Workbook();

            Sheets sheets = spreadSheet.WorkbookPart.Workbook.GetFirstChild<Sheets>();
            if (sheets == null)
                spreadSheet.WorkbookPart.Workbook.Sheets = new Sheets();

            return spreadSheet;
        }
        
        private static int GetColumnNumber(string reference)
        {
            int ci = 0;
            reference = reference.ToUpper();

            for (int ix = 0; ix < reference.Length && reference[ix] >= 'A'; ix++)
                ci = ci * 26 + (reference[ix] - 64);

            return ci;
        }
        
        /* Append Cell with column Name */
        public static Cell AppendCell(WorkbookPart workbookPart, WorksheetPart worksheetPart, string text, string columnName, uint rowIndex, string bold = "no", string border = "no", bool isNumber = false, DoubleValue dwidth = null, string hyperlink = "no")
        {
            Cell cell = null;
            if (text != null)
            {
                var row = GetRow(worksheetPart.Worksheet, rowIndex);

                var cellReference = columnName + rowIndex;      // e.g. A1
                var columnNo = GetColumnNumber(cellReference);

                cell = isNumber ? new Cell { CellValue = new CellValue(text), DataType = new EnumValue<CellValues>(CellValues.Number), CellReference = cellReference }
                                : new Cell(new InlineString(new Text(text))) { DataType = CellValues.InlineString, CellReference = cellReference };

                row.AppendChild(cell);

                if (dwidth != null)
                    SetColumnWidth(worksheetPart.Worksheet, (uint)columnNo, dwidth);

                if (bold != "no" || border != "no" || hyperlink != "no")
                    FormatCell(workbookPart, worksheetPart, cell, bold, border, "left", 11, null, hyperlink);
            }

            return cell;
        }
        
        private static Row GetRow(Worksheet worksheet, uint rowIndex)
        {
            //var row = worksheet.GetFirstChild<SheetData>().Elements<Row>().FirstOrDefault(r => r.RowIndex == rowIndex);
            var rows = worksheet.First().Elements<Row>().ToList();
            var row = rows.FirstOrDefault(r => r.RowIndex == rowIndex);
            if (row == null)
            {
                row = new Row { RowIndex = rowIndex };
                // ReSharper disable once PossiblyMistakenUseOfParamsMethod
                worksheet.GetFirstChild<SheetData>().Append(row);
            }
            return row;
        }

        public static WorksheetPart InsertWorksheet(SpreadsheetDocument spreadSheet, string name, uint sheetId)
        {
            spreadSheet = CreateWorkbook(spreadSheet);

            WorksheetPart newWorksheetPart = spreadSheet.WorkbookPart.AddNewPart<WorksheetPart>();
            newWorksheetPart.Worksheet = new Worksheet(new SheetData());

            Sheets sheets = spreadSheet.WorkbookPart.Workbook.GetFirstChild<Sheets>();
            string relationshipId = spreadSheet.WorkbookPart.GetIdOfPart(newWorksheetPart);

            if (sheets.Elements<Sheet>().Any())
            {
                sheetId = sheets.Elements<Sheet>().Select(s => s.SheetId.Value).Max() + 1;
            }

            string sheetName = (name == null) ? $"Sheet_{Guid.NewGuid().ToString().Substring(0, 4)}" : (name.Length > 31 ? $"{name.Substring(0, 28)}..." : name);

            Sheet sheet = new Sheet() { Id = relationshipId, SheetId = sheetId, Name = sheetName };
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            sheets.Append(sheet);

            newWorksheetPart.Worksheet.Save();

            return newWorksheetPart;
        }

        private static void SetColumnWidth(Worksheet worksheet, uint columnIndex, DoubleValue dwidth)
        {
            Columns cs = worksheet.GetFirstChild<Columns>();  // columnIndex: e.g. A=1, B=2, C=3 etc.,
            if (cs != null)
            {
                var ic = cs.Elements<Column>().Where(r => r.Min == columnIndex).Where(r => r.Max == columnIndex).ToList();
                if (ic.Any())
                {
                    Column c = ic.First();
                    c.Width = dwidth;
                }
                else
                {
                    Column c = new Column() { Min = columnIndex, Max = columnIndex, Width = dwidth, CustomWidth = true };
                    // ReSharper disable once PossiblyMistakenUseOfParamsMethod
                    cs.Append(c);
                }
            }
            else
            {
                cs = new Columns();
                Column c = new Column() { Min = columnIndex, Max = columnIndex, Width = dwidth, CustomWidth = true };
                // ReSharper disable once PossiblyMistakenUseOfParamsMethod
                cs.Append(c);
                worksheet.InsertAfter(cs, worksheet.GetFirstChild<SheetFormatProperties>());
            }
        }

        private static void FormatCell(WorkbookPart workbookPart, WorksheetPart worksheetPart, Cell cell, string bold = "no", string border = "no", string alignment = "left", int fontSize = 11, string color = null, string hyperLink = "no")
        {
            CellFormat cellFormat = cell.StyleIndex != null ? GetCellFormat(workbookPart, cell.StyleIndex).CloneNode(true) as CellFormat : new CellFormat();

            if (cellFormat != null)
            {
                if (bold == "yes")
                    cellFormat.FontId = InsertFont(workbookPart, GenerateFont(fontSize));

                if (hyperLink == "yes")
                {
                    var fColor = new Color();
                    fColor.Rgb = new HexBinaryValue("0000ff");
                    cellFormat.FontId = InsertFont(workbookPart, GenerateFontAsLink(fontSize, fColor));
                }

                if (!string.IsNullOrEmpty(color))
                    cellFormat.FillId = InsertFill(workbookPart, GenerateFill(color));

                if (border == "yes")
                    cellFormat.BorderId = InsertBorder(workbookPart, GenerateBorder("all"));

                if (alignment == "right")
                    cellFormat.Alignment = new Alignment { Horizontal = HorizontalAlignmentValues.Right, Vertical = VerticalAlignmentValues.Center };
                else if (alignment == "center")
                    cellFormat.Alignment = new Alignment { Horizontal = HorizontalAlignmentValues.Center, Vertical = VerticalAlignmentValues.Center };

                cell.StyleIndex = InsertCellFormat(workbookPart, cellFormat);
            }
        }
        
        private static CellFormat GetCellFormat(WorkbookPart workbookPart, uint styleIndex)
        {
            return workbookPart.WorkbookStylesPart.Stylesheet.Elements<CellFormats>().First().Elements<CellFormat>().ElementAt((int)styleIndex);
        }
        
        private static uint InsertFont(WorkbookPart workbookPart, Font font)
        {
            Fonts fonts = workbookPart.WorkbookStylesPart.Stylesheet.Elements<Fonts>().First();
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            if (font != null) fonts.Append(font);
            return fonts.Count++;
        }

        private static uint InsertFill(WorkbookPart workbookPart, Fill fill)
        {
            Fills fills = workbookPart.WorkbookStylesPart.Stylesheet.Elements<Fills>().First();
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            if (fill != null) fills.Append(fill);
            return fills.Count++;
        }

        private static uint InsertBorder(WorkbookPart workbookPart, Border border)
        {
            Borders borders = workbookPart.WorkbookStylesPart.Stylesheet.Elements<Borders>().First();
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            if (border != null) borders.Append(border);
            return borders.Count++;
        }

        private static uint InsertCellFormat(WorkbookPart workbookPart, CellFormat cellFormat)
        {
            CellFormats cellFormats = workbookPart.WorkbookStylesPart.Stylesheet.Elements<CellFormats>().First();
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            if (cellFormat != null) cellFormats.Append(cellFormat);
            return cellFormats.Count++;
        }

        private static Fill GenerateFill(string color)
        {
            Fill fill = new Fill();

            PatternFill patternFill = new PatternFill { PatternType = PatternValues.Solid };
            ForegroundColor foregroundColor1 = new ForegroundColor { Rgb = color };
            BackgroundColor backgroundColor1 = new BackgroundColor { Indexed = 64U };

            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            patternFill.Append(foregroundColor1);
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            patternFill.Append(backgroundColor1);
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            fill.Append(patternFill);

            return fill;
        }

        private static Font GenerateFont(int fontSize = 11, Color color = null)
        {
            var font = new Font(new FontSize { Val = fontSize }, new Bold(), color);
            if (color != null)
                font.Color = color;
            return font;
        }

        private static Font GenerateFontAsLink(int fontSize = 11, Color color = null)
        {
            var font = new Font(new FontSize { Val = fontSize }, new Underline() { Val = UnderlineValues.Single });
            if (color != null)
                font.Color = color;
            return font;
        }

        private static Border GenerateBorder(string side, BorderStyleValues borderType = BorderStyleValues.Thin)
        {
            Border border2 = new Border();

            LeftBorder leftBorder2 = new LeftBorder { Style = borderType };
            Color color1 = new Color { Indexed = 64U };

            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            leftBorder2.Append(color1);

            RightBorder rightBorder2 = new RightBorder() { Style = borderType };
            Color color2 = new Color() { Indexed = 64U };

            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            rightBorder2.Append(color2);

            TopBorder topBorder2 = new TopBorder() { Style = borderType };
            Color color3 = new Color() { Indexed = 64U };

            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            topBorder2.Append(color3);

            BottomBorder bottomBorder2 = new BottomBorder() { Style = borderType };
            Color color4 = new Color() { Indexed = 64U };

            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            bottomBorder2.Append(color4);
            DiagonalBorder diagonalBorder2 = new DiagonalBorder();

            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            if (side == "left") border2.Append(leftBorder2);
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            else if (side == "right") border2.Append(rightBorder2);
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            else if (side == "top") border2.Append(topBorder2);
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            else if (side == "bottom") border2.Append(bottomBorder2);
            // ReSharper disable once PossiblyMistakenUseOfParamsMethod
            else if (side == "diagonal") border2.Append(diagonalBorder2);
            else if (side == "bottomAndTop")
            {
                // ReSharper disable once PossiblyMistakenUseOfParamsMethod
                border2.Append(topBorder2);
                // ReSharper disable once PossiblyMistakenUseOfParamsMethod
                border2.Append(bottomBorder2);
            }
            else if (side == "all")
            {
                // ReSharper disable once PossiblyMistakenUseOfParamsMethod
                border2.Append(leftBorder2);
                // ReSharper disable once PossiblyMistakenUseOfParamsMethod
                border2.Append(rightBorder2);
                // ReSharper disable once PossiblyMistakenUseOfParamsMethod
                border2.Append(topBorder2);
                // ReSharper disable once PossiblyMistakenUseOfParamsMethod
                border2.Append(bottomBorder2);
                // ReSharper disable once PossiblyMistakenUseOfParamsMethod
                border2.Append(diagonalBorder2);
            }

            return border2;
        }
    }
}

