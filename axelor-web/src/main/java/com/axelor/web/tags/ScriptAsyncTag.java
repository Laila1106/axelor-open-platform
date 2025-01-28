/*
 * Axelor Business Solutions
 *
 * Copyright (C) 2005-2025 Axelor (<http://axelor.com>).
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
package com.axelor.web.tags;

import java.io.IOException;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;

public class ScriptAsyncTag extends ScriptTag {

  @Override
  public void doTag() throws JspException, IOException {
    final JspWriter writer = getJspContext().getOut();
    writer.write("<script>$(function () {\n");
    try {
      super.doTag();
    } finally {
      writer.write("});</script>");
    }
  }

  @Override
  protected void doTag(String src) throws IOException {
    final JspWriter writer = getJspContext().getOut();
    final String output = "  $.getScript(\"" + src + "\");";
    writer.println(output);
  }
}
