﻿//------------------------------------------------------------------------------
//  <auto-generated>
//     This code was generated by a tool.
//     Runtime version: 4.0.30319.42000
//     Generator      : XSharp.CodeDomProvider 2.8.0.0
//     Timestamp      : 15/09/2021 11:34:02
//     
//     Changes to this file may cause incorrect behavior and may be lost if
//     the code is regenerated.
//  </auto-generated>
//------------------------------------------------------------------------------
BEGIN NAMESPACE XanthiClientTest

    PUBLIC PARTIAL CLASS MainWindow
        PRIVATE groupBox1 AS System.Windows.Forms.GroupBox
        PRIVATE label2 AS System.Windows.Forms.Label
        PRIVATE label1 AS System.Windows.Forms.Label
        PRIVATE portNumber AS System.Windows.Forms.NumericUpDown
        PRIVATE comboIPList AS System.Windows.Forms.ComboBox
        PRIVATE groupBox2 AS System.Windows.Forms.GroupBox
        PRIVATE tbPayLoad AS System.Windows.Forms.TextBox
        PRIVATE tbCommand AS System.Windows.Forms.TextBox
        PRIVATE tbCode AS System.Windows.Forms.TextBox
        PRIVATE label5 AS System.Windows.Forms.Label
        PRIVATE label4 AS System.Windows.Forms.Label
        PRIVATE label3 AS System.Windows.Forms.Label
        PRIVATE buttonSend AS System.Windows.Forms.Button
        PRIVATE statusStrip1 AS System.Windows.Forms.StatusStrip
        PRIVATE statusLabel AS System.Windows.Forms.ToolStripStatusLabel
        PRIVATE components := NULL AS System.ComponentModel.IContainer

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        PROTECTED METHOD Dispose(disposing AS LOGIC) AS VOID  STRICT

            IF (disposing .AND. (components != null))
                components:Dispose()
            ENDIF
            SUPER:Dispose(disposing)
   RETURN

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        PRIVATE METHOD InitializeComponent() AS VOID STRICT
            SELF:groupBox1 := System.Windows.Forms.GroupBox{}
            SELF:portNumber := System.Windows.Forms.NumericUpDown{}
            SELF:label2 := System.Windows.Forms.Label{}
            SELF:label1 := System.Windows.Forms.Label{}
            SELF:comboIPList := System.Windows.Forms.ComboBox{}
            SELF:buttonSend := System.Windows.Forms.Button{}
            SELF:groupBox2 := System.Windows.Forms.GroupBox{}
            SELF:tbPayLoad := System.Windows.Forms.TextBox{}
            SELF:tbCommand := System.Windows.Forms.TextBox{}
            SELF:tbCode := System.Windows.Forms.TextBox{}
            SELF:label5 := System.Windows.Forms.Label{}
            SELF:label4 := System.Windows.Forms.Label{}
            SELF:label3 := System.Windows.Forms.Label{}
            SELF:statusStrip1 := System.Windows.Forms.StatusStrip{}
            SELF:statusLabel := System.Windows.Forms.ToolStripStatusLabel{}
            SELF:groupBox1:SuspendLayout()
            ((System.ComponentModel.ISupportInitialize)(SELF:portNumber)):BeginInit()
            SELF:groupBox2:SuspendLayout()
            SELF:statusStrip1:SuspendLayout()
            SELF:SuspendLayout()
            // 
            // groupBox1
            // 
            SELF:groupBox1:Controls:Add(SELF:portNumber)
            SELF:groupBox1:Controls:Add(SELF:label2)
            SELF:groupBox1:Controls:Add(SELF:label1)
            SELF:groupBox1:Controls:Add(SELF:comboIPList)
            SELF:groupBox1:Location := System.Drawing.Point{12, 12}
            SELF:groupBox1:Name := "groupBox1"
            SELF:groupBox1:Size := System.Drawing.Size{770, 59}
            SELF:groupBox1:TabIndex := 0
            SELF:groupBox1:TabStop := false
            SELF:groupBox1:Text := "Server Info"
            // 
            // portNumber
            // 
            SELF:portNumber:Location := System.Drawing.Point{389, 22}
            SELF:portNumber:Maximum := DECIMAL{<INT>{ 65535, 0, 0, 0 }}
            SELF:portNumber:Name := "portNumber"
            SELF:portNumber:Size := System.Drawing.Size{71, 22}
            SELF:portNumber:TabIndex := 4
            // 
            // label2
            // 
            SELF:label2:AutoSize := true
            SELF:label2:Location := System.Drawing.Point{341, 24}
            SELF:label2:Name := "label2"
            SELF:label2:Size := System.Drawing.Size{42, 17}
            SELF:label2:TabIndex := 2
            SELF:label2:Text := "Port :"
            // 
            // label1
            // 
            SELF:label1:AutoSize := true
            SELF:label1:Location := System.Drawing.Point{13, 24}
            SELF:label1:Name := "label1"
            SELF:label1:Size := System.Drawing.Size{28, 17}
            SELF:label1:TabIndex := 1
            SELF:label1:Text := "IP :"
            // 
            // comboIPList
            // 
            SELF:comboIPList:DropDownStyle := System.Windows.Forms.ComboBoxStyle.DropDownList
            SELF:comboIPList:FormattingEnabled := true
            SELF:comboIPList:Location := System.Drawing.Point{67, 21}
            SELF:comboIPList:Name := "comboIPList"
            SELF:comboIPList:Size := System.Drawing.Size{235, 24}
            SELF:comboIPList:TabIndex := 0
            // 
            // buttonSend
            // 
            SELF:buttonSend:Location := System.Drawing.Point{296, 86}
            SELF:buttonSend:Name := "buttonSend"
            SELF:buttonSend:Size := System.Drawing.Size{75, 23}
            SELF:buttonSend:TabIndex := 1
            SELF:buttonSend:Text := "Send"
            SELF:buttonSend:UseVisualStyleBackColor := true
            SELF:buttonSend:Click += System.EventHandler{ SELF, @buttonSend_Click() }
            // 
            // groupBox2
            // 
            SELF:groupBox2:Controls:Add(SELF:tbPayLoad)
            SELF:groupBox2:Controls:Add(SELF:tbCommand)
            SELF:groupBox2:Controls:Add(SELF:tbCode)
            SELF:groupBox2:Controls:Add(SELF:label5)
            SELF:groupBox2:Controls:Add(SELF:label4)
            SELF:groupBox2:Controls:Add(SELF:label3)
            SELF:groupBox2:Controls:Add(SELF:buttonSend)
            SELF:groupBox2:Location := System.Drawing.Point{12, 77}
            SELF:groupBox2:Name := "groupBox2"
            SELF:groupBox2:Size := System.Drawing.Size{770, 122}
            SELF:groupBox2:TabIndex := 2
            SELF:groupBox2:TabStop := false
            SELF:groupBox2:Text := "Message"
            // 
            // tbPayLoad
            // 
            SELF:tbPayLoad:Location := System.Drawing.Point{96, 87}
            SELF:tbPayLoad:Name := "tbPayLoad"
            SELF:tbPayLoad:Size := System.Drawing.Size{100, 22}
            SELF:tbPayLoad:TabIndex := 10
            // 
            // tbCommand
            // 
            SELF:tbCommand:Location := System.Drawing.Point{96, 57}
            SELF:tbCommand:Name := "tbCommand"
            SELF:tbCommand:Size := System.Drawing.Size{100, 22}
            SELF:tbCommand:TabIndex := 9
            // 
            // tbCode
            // 
            SELF:tbCode:Location := System.Drawing.Point{96, 28}
            SELF:tbCode:Name := "tbCode"
            SELF:tbCode:Size := System.Drawing.Size{100, 22}
            SELF:tbCode:TabIndex := 3
            // 
            // label5
            // 
            SELF:label5:AutoSize := true
            SELF:label5:Location := System.Drawing.Point{13, 90}
            SELF:label5:Name := "label5"
            SELF:label5:Size := System.Drawing.Size{67, 17}
            SELF:label5:TabIndex := 8
            SELF:label5:Text := "Payload :"
            // 
            // label4
            // 
            SELF:label4:AutoSize := true
            SELF:label4:Location := System.Drawing.Point{13, 60}
            SELF:label4:Name := "label4"
            SELF:label4:Size := System.Drawing.Size{79, 17}
            SELF:label4:TabIndex := 7
            SELF:label4:Text := "Command :"
            // 
            // label3
            // 
            SELF:label3:AutoSize := true
            SELF:label3:Location := System.Drawing.Point{13, 31}
            SELF:label3:Name := "label3"
            SELF:label3:Size := System.Drawing.Size{49, 17}
            SELF:label3:TabIndex := 6
            SELF:label3:Text := "Code :"
            // 
            // statusStrip1
            // 
            SELF:statusStrip1:ImageScalingSize := System.Drawing.Size{20, 20}
            SELF:statusStrip1:Items:AddRange(<System.Windows.Forms.ToolStripItem>{ SELF:statusLabel })
            SELF:statusStrip1:Location := System.Drawing.Point{0, 456}
            SELF:statusStrip1:Name := "statusStrip1"
            SELF:statusStrip1:Size := System.Drawing.Size{794, 26}
            SELF:statusStrip1:TabIndex := 3
            SELF:statusStrip1:Text := "statusStrip1"
            // 
            // statusLabel
            // 
            SELF:statusLabel:Name := "statusLabel"
            SELF:statusLabel:Size := System.Drawing.Size{151, 20}
            SELF:statusLabel:Text := "toolStripStatusLabel1"
            // 
            // MainWindow
            // 
            SELF:AutoScaleDimensions := System.Drawing.SizeF{8, 16}
            SELF:AutoScaleMode := System.Windows.Forms.AutoScaleMode.Font
            SELF:ClientSize := System.Drawing.Size{794, 482}
            SELF:Controls:Add(SELF:statusStrip1)
            SELF:Controls:Add(SELF:groupBox2)
            SELF:Controls:Add(SELF:groupBox1)
            SELF:MaximizeBox := false
            SELF:MinimizeBox := false
            SELF:Name := "MainWindow"
            SELF:Text := "Test Xanthi"
            SELF:Load += System.EventHandler{ SELF, @MainWindow_Load() }
            SELF:groupBox1:ResumeLayout(false)
            SELF:groupBox1:PerformLayout()
            ((System.ComponentModel.ISupportInitialize)(SELF:portNumber)):EndInit()
            SELF:groupBox2:ResumeLayout(false)
            SELF:groupBox2:PerformLayout()
            SELF:statusStrip1:ResumeLayout(false)
            SELF:statusStrip1:PerformLayout()
            SELF:ResumeLayout(false)
            SELF:PerformLayout()

        #endregion
    END CLASS 
END NAMESPACE