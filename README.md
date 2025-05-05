<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
</head>
<body>
  <h1>Paystack-API Integration</h1>

  <p><strong>Demo URL:</strong> <a href="https://r0mlg8oc0e1zzbk-dbdroplet01.adb.us-ashburn-1.oraclecloudapps.com/ords/r/saas/paystack-api" target="_blank">paystack-api</a></p>

  <h2>Steps</h2>
  <ol>
    <li>
      <p><strong>Run the reference sequence</strong> on your database:</p>
      <pre><code>@S_TRAN_REFERENCE.sql</code></pre>
    </li>
    <li>
      <p><strong>Import the application</strong> into your APEX workspace:</p>
      <pre><code>f103.sql</code></pre>
    </li>
    <li>
      <p><strong>Update your Paystack test keys</strong> in two places:</p>
      <ul>
        <li>Page 2 “Payvalidate” process (before region)</li>
        <li>Page 1 “pay_link” process</li>
      </ul>
      <p>Use the public and secret test keys provided by your Paystack dashboard.</p>
    </li>
  </ol>
</body>
</html>
