<?php

declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

json_response([
    'success' => true,
    'message' => 'API is ready.',
]);
