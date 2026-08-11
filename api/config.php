<?php

declare(strict_types=1);

return [
    'database' => [
        'host' => 'localhost:3306',
        'name' => 'honeyang_test_flow',
        'user' => 'honeyang_tide',
        'password' => 'aktkzlk1!@',
        'charset' => 'utf8mb4',
    ],
    'cors' => [
        'allowed_origins' => [
            'https://honeyangler.gtz.kr',
            'http://test-flow.dvelop.kr',
            'https://test-flow.dvelop.kr',
            'http://test-flow.mkvelop.kr',
            'https://test-flow.mkvelop.kr',
            'http://localhost:3000',
            'http://127.0.0.1:3000',
            'http://localhost:3003',
            'http://127.0.0.1:3003',
            'http://localhost:5173',
            'http://127.0.0.1:5173',
        ],
    ],
    'auth' => [
        'login_code_minutes' => 10,
        'session_days' => 30,
        'remember_days' => 30,
    ],
    'mail' => [
        'from' => 'no-reply@honeyangler.gtz.kr',
        'from_name' => 'Learning with Tori',
    ],
];
