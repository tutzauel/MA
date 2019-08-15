# Konzeption und prototypische Implementierung eines leistungsoptimierten Archivierungssystems
Im Rahmen der Masterthesis wurde unteranderem ein Archivierungsverfahren prototypisch implementiert. Alle Dateien inklusive der Java-Klassen sowie auch die Sql-Scripte die genutzt wurden, sind in diesem Projekt hinterlegt. Um einen einfacheren Start zu bekommen, die unterschieldichen Komponente miteinander kommunizieren zu lassen wurde diese Readme, die sich in folgenden in vier Punkte gliedert, erstellt:
- Einrichtung von Eclipse
- Erklärung zu den in Java/Hibernate enthaltenen Klassen
- Vorgehen diese Implementierung zu starten
- Hinweise

Einrichtung:
- Download Eclipse: eclipse_photon_x64 (https://www.eclipse.org/)
- Download Java runtime: jre1.8.0_91 (https://www.java.com/de/)
- Download Enterprise Application Plattform: boss-eap-7.0.8 (https://www.redhat.com/en)
- Classpath's setzen
- Workspace importieren (../Java.zip)
- Datenbank Konfiguration in der Standalone.xml in Zeile: 380 - 403 anpassen (../jboss-eap-7.0.8\standalone\configuration\standalone.xml)

Java/Hibernate
- Klasse Orders, OrderItem, Product und Customer werden in die Datenbank abgebildet
- Klasse OrderItemCompositeKey wird verwendet um den zusammen gesetzten Schlüssel aus der Tabelle OrderItem zu representieren
- Klasse TestBean ist das Data Access Object. Mit diesem werden Methoden ausgeführt um Änderungen am Datenmodell vorzunehmen. (Zu beachten ist, dass in der persistence.xml, <property name="hibernate.hbm2ddl.auto" value="update"/>, bei Start des Servers drauf zu achten ist was genau gemacht werden soll. Wenn das Datenmodell angepasst werden soll ist Update die richtige Value. Zum Test, dass wenn bei jedem Neustart des Servers, alles vorhher gelöscht werden soll kann man diese auf create-drop einstelle. Mehr dazu in der Dokumentation

Vorgehen:
- Eclipse JBoss Server starten und das Datenmodell mit Inhalt erstellen lassen (SQL Data Generator kann hier zur Hilfe genommen werden)
- Fals Data Generator zur Hilfe genommen wurde muss das Datenmodell einem update unterzogen werden (../SQL/DatenmodelllUpdaten.sql)
- Das erstellte Datenmodell partitionieren (../SQL/Partitionierung_PoC.sql)
- Der Test erfolgt mit den in der SQL Datei vorhandenem Code (../SQL/Test.sql)

Hinweise:
- Eclipse Server mit Adminrechten starten
- Management Konsole: http://127.0.0.1:9990/console/App.html (admin/admin)
- Im SQL Server Konfigurationsmanager TCP/IP erlauben und Dienst neu starten, dass die Änderungen wirksam werden
- Der SQL Data Generator ist nur notwendig wenn im Datenmodell Datensätze erzeugt werden sollen, die realistisch sind. In der TestBean.Java ist eine Methode erzeugeTestDaten() mit dieser das Datenmodell mit Werten befüllt werden kann. 
- Der Ordner SQL enthällt weitere Dateien welche genutzt werden können um sich beispielsweise saubere Views anzeigen zu lassen.

Autor
Leonard Tutzauer
